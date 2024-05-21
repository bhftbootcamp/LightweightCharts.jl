import React, { useEffect, useState, useRef } from 'react';
import { createChart, TickMarkType, LineStyle } from 'lightweight-charts';

import { VertLine } from '../plugins/vertical_line/vertical_line.ts';
import { DeltaTooltipPrimitive } from '../plugins/delta_tooltip/delta_tooltip.ts';
import { TrendLine } from '../plugins/trend_line/trend_line.ts';
import { CrosshairHighlightPrimitive } from '../plugins/highlight_bar_crosshair/highlight_bar_crosshair.ts';
import { TooltipPrimitive } from '../plugins/tooltip/tooltip.ts';

import Label from './label.jsx';
import { DateTimeString, DateString, TimeString } from '../helpers/time.ts';
import { rescaleAndShiftDates } from '../helpers/rescale.ts';
import Copyright from './copyright.jsx';

const ChartPanel = ({ settings, id, setPanels }) => {
    const panelId = `${settings.x}${settings.y}`;
    const ref = useRef(null);

    const [panel, setPanel] = useState(null);
    const [charts, setCharts] = useState({});
    const [labels, setLabels] = useState([]);

    useEffect(() => {
        if (!settings.rescale) {
            rescaleAndShiftDates(settings);
        }
        createPanel();
    }, []);

    const createPanel = () => {
        if (ref.current.children[0]) return;

        const handleResize = () => {
            newChart.applyOptions({ width: ref.current.clientWidth });
            newChart.applyOptions({ height: ref.current.clientHeight });
        };

        let newChart = createChart(ref.current, {
            width: ref.current.offsetWidth,
            height: ref.current.offsetHeight,
            layout: {
                backgroundColor: '#ffffff',
                textColor: 'rgba(33, 56, 77, 1)',
            },
            grid: {
                vertLines: {
                    color: 'rgba(197, 203, 206, 0.7)',
                },
                horzLines: {
                    color: 'rgba(197, 203, 206, 0.7)',
                },
            },
            localization: {
                timeFormatter: (time) => {
                    return DateTimeString(
                        time,
                        settings.minResolution,
                        settings.dateShift,
                        settings.dateScale
                    );
                },
            },
            timeScale: {
                timeVisible: true,
                secondsVisible: settings.secondsVisible,
                barSpacing: settings.barSpacing,
                minBarSpacing: settings.minBarSpacing,
                tickMarkFormatter: (time, tickMarkType, locale) => {
                    if (tickMarkType <= TickMarkType.DayOfMonth) {
                        return DateString(
                            time,
                            settings.minResolution,
                            settings.dateShift,
                            settings.dateScale
                        );
                    } else {
                        return TimeString(
                            time,
                            settings.minResolution,
                            settings.dateShift,
                            settings.dateScale
                        );
                    }
                },
            },
            rightPriceScale: {
                borderColor: 'rgba(197, 203, 206, 1)',
            },
            leftPriceScale: {
                borderColor: 'rgba(197, 203, 206, 1)',
            },
        });

        window.addEventListener('resize', handleResize);

        setPanel(newChart);
        setPanels((state) => [...state, newChart]);
        createSeriesMap(newChart);
        setMarginLabels(150);
    };

    const setMarginLabels = (timeout) => {
        setTimeout(() => {
            let offset =
                ref.current.getElementsByTagName('td')[0]?.clientWidth + 5;
            ref.current.previousSibling.style.marginLeft = offset + 'px';
        }, timeout);
    };

    const createSeriesMap = (panel) => {
        let charts = {};

        if (settings.charts == null) {
            return;
        }

        let visibleLeftScale = false;
        let visibleRightScale = false;

        settings.charts.forEach((chart) => {
            charts[chart.id] = panel[chart.type](chart.settings);

            charts[chart.id].applyOptions({
                priceFormat: {
                    precision: chart.settings.precision,
                    minMove: 1 / 10 ** chart.settings.precision,
                },
            });

            charts[chart.id].applyOptions({
                autoscaleInfoProvider: (original) => {
                    const res = original();
                    if (res !== null) {
                        let isLeftPriceScaleId = chart.settings.priceScaleId === "left";
                        const minYValue = isLeftPriceScaleId
                            ? (settings.leftMinY ?? settings.minY)
                            : (settings.rightMinY ?? settings.minY);

                        const maxYValue = isLeftPriceScaleId
                            ? (settings.leftMaxY ?? settings.maxY)
                            : (settings.rightMaxY ?? settings.maxY);

                        if (minYValue !== null) {
                            res.priceRange.minValue = minYValue;
                        }
                        if (maxYValue !== null) {
                            res.priceRange.maxValue = maxYValue;
                        }
                    }
                    return res;
                },
            });

            if (!chart.settings.visible) {
                charts[chart.id].applyOptions({
                    visible: chart.settings.visible,
                });

                setTimeout(() => {
                    let label = document.getElementById(
                        `label${panelId}${chart.id}`
                    );
                    label?.classList.add(`hide-chart`);
                }, 50);
            }

            if (
                chart.settings.priceScaleId === 'left' &&
                chart.settings.visible
            ) {
                visibleLeftScale = true;
            }

            if (
                chart.settings.priceScaleId === 'right' &&
                chart.settings.visible
            ) {
                visibleRightScale = true;
            }

            charts[chart.id].setData(chart.data);
        });

        panel.applyOptions({
            leftPriceScale: {
                visible: visibleLeftScale,
            },
            rightPriceScale: {
                visible: visibleRightScale,
            },
        });

        if (settings.crosshair) {
            panel.applyOptions({
                crosshair: {
                    vertLine: {
                        width: 8,
                        color: '#C3BCDB44',
                        style: LineStyle.Solid,
                        labelBackgroundColor: '#9B7DFF',
                    },
                    horzLine: {
                        color: '#9B7DFF',
                        labelBackgroundColor: '#9B7DFF',
                    },
                },
            });
        }

        setCharts(charts);
        setLabels(settings.charts);
        createPlagin(charts, panel);

        if (settings.charts.length > 1) sortCharts(settings.charts);
    };

    const createPlagin = (seriesMap, panel) => {
        for (const chart of settings.charts) {
            for (const plugin of chart.plugins) {
                switch (plugin.type) {
                    case 'addVertLine':
                        const vertLine = new VertLine(
                            panel,
                            seriesMap[chart.id],
                            chart.data[plugin.settings.index].time,
                            plugin.settings
                        );
                        seriesMap[chart.id].attachPrimitive(vertLine);
                        break;

                    case 'addDeltaTooltip':
                        const deltaTooltip = new DeltaTooltipPrimitive(
                            settings.dateShift,
                            settings.dateScale,
                            plugin.settings
                        );
                        seriesMap[chart.id].attachPrimitive(deltaTooltip);
                        break;
                    case 'addTrendLine':
                        const trend = new TrendLine(
                            panel,
                            seriesMap[chart.id],
                            {
                                time: chart.data[plugin.settings.point1.index]
                                    .time,
                                price: plugin.settings.point1.price,
                            },
                            {
                                time: chart.data[plugin.settings.point2.index]
                                    .time,
                                price: plugin.settings.point2.price,
                            },
                            plugin.settings
                        );
                        seriesMap[chart.id].attachPrimitive(trend);
                        break;
                    case 'addCrosshairHighlightBar':
                        const highlightPrimitive =
                            new CrosshairHighlightPrimitive(plugin.settings);
                        seriesMap[chart.id].attachPrimitive(highlightPrimitive);
                        break;
                    case 'addTooltip':
                        const tooltipPrimitive = new TooltipPrimitive(
                            settings.dateShift,
                            settings.dateScale,
                            plugin.settings
                        );
                        seriesMap[chart.id].attachPrimitive(tooltipPrimitive);
                        break;
                    default:
                        break;
                }
            }
        }
    };

    const sortCharts = (charts) => {
        let oldLabels = [...charts];

        oldLabels.sort(function (first, second) {
            let firstName = first.labelName;
            let secondName = second.labelName;

            if (firstName < secondName) {
                return -1;
            } else if (firstName > secondName) {
                return 1;
            } else {
                return 0;
            }
        });

        setLabels(oldLabels);
    };

    const searchLabel = (value) => {
        let searchValue = value.toLowerCase();
        let regex = new RegExp(searchValue, 'g');

        let searchArray = new Array();

        for (let label of settings.charts) {
            let name = label.labelName.toLowerCase();

            if (!!name.match(regex)) {
                searchArray.push(label);
            }
        }

        setLabels(searchArray);
    };

    return (
        <div className="grid-item" style={{ gridArea: `${id}` }}>
            <div className="grid-area">
                <Label
                    panelId={panelId}
                    labels={labels}
                    minChartsForSearch={settings.minChartsForSearch}
                    charts={charts}
                    panel={panel}
                    searchLabel={searchLabel}
                    setMarginLabels={setMarginLabels}
                />
                <div className="charts" ref={ref}></div>
                {settings.copyright ? <Copyright chart={ref} /> : <></>}
            </div>
        </div>
    );
};

export default ChartPanel;
