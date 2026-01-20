import React, { useEffect, useState, useRef, useMemo } from 'react';
import { createChart, TickMarkType } from 'lightweight-charts';
import * as Color from 'color';

import { VertLine } from '../plugins/vertical_line/vertical_line.ts';
import { DeltaTooltipPrimitive } from '../plugins/delta_tooltip/delta_tooltip.ts';
import { TrendLine } from '../plugins/trend_line/trend_line.ts';
import { CrosshairHighlightPrimitive } from '../plugins/highlight_bar_crosshair/highlight_bar_crosshair.ts';
import { TooltipPrimitive } from '../plugins/tooltip/tooltip.ts';

import Label from './label.jsx';
import { DateTimeString, DateString, TimeString } from '../helpers/time.ts';
import { rescaleAndShiftDates } from '../helpers/rescale.ts';
import ChartsManager from './charts_manager.jsx';

function convertToRGBA(color, alpha = 1) {
    if (!color) return;
    const namedColors = {
        Crimson: "DC143C",
        DarkTurquoise: "00CED1",
        ForestGreen: "228B22",
        RoyalBlue: "4169E1",
        Indigo: "4B0082",
        DarkOrange: "FF8C00",
        DarkRed: "8B0000",
        DarkSlateGray: "2F4F4F",
        OliveDrab: "6B8E23",
        MediumPurple: "9370DB",
        SteelBlue: "4682B4",
        Goldenrod: "DAA520",
        Teal: "008080",
        SlateBlue: "6A5ACD",
        FireBrick: "B22222",
        Sienna: "A0522D",
        DarkOliveGreen: "556B2F",
    };

    if (namedColors[color]) {
        const hex = namedColors[color];
        const r = parseInt(hex.slice(0, 2), 16);
        const g = parseInt(hex.slice(2, 4), 16);
        const b = parseInt(hex.slice(4, 6), 16);
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }
    try {
        let colorModel = Color(color);
        return `rgba(${colorModel.color[0]}, ${colorModel.color[1]}, ${colorModel.color[2]}, ${alpha})`;
    } catch (err) {
        return color;
    }
}

const ChartPanel = ({ settings, id, setPanels }) => {
    const panelId  = `${settings.x}${settings.y}`;
    const ref      = useRef(null);
    const panelRef = useRef(null);
    const tooltip  = useRef(null);

    const [openTool, setOpenTool] = useState(settings.defaultLegendVisible);
    const [panel, setPanel]       = useState(null);
    const [labels, setLabels]     = useState([]);
    const chartsSeries            = useRef({});
    const activeSeries            = useRef(null);
    const styleSettings           = useRef({});
    const [fullscreen, setFullscreen] = useState(false);

    useEffect(() => {
        if (!settings.rescale) {
            rescaleAndShiftDates(settings);
        }
        createPanel();
    }, []);

    const debounce = (func, delay) => {
        let timeoutId;
        
        return function executedFunction(...args) {
          clearTimeout(timeoutId);
          timeoutId = setTimeout(() => func.apply(this, args), delay);
        };
    };

    const createPanel = () => {
        if (ref.current.children[0]) return;

        let styles = {};
        settings.charts.forEach((chart) => {
            styles[chart.id] = chart.settings;
        });
        styleSettings.current = styles;

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
                mode: settings.mode,
            },
            leftPriceScale: {
                borderColor: 'rgba(197, 203, 206, 1)',
                mode: settings.mode,
            },
        });

        settings.tooltip && newChart.subscribeCrosshairMove(debounce((param) => {
            const tooltipRef = tooltip.current;
            if (!param || !param.seriesData) {
                tooltipRef.style.opacity = '0';
                return;
            }

            let seriesData = new Array();
            param.seriesData.forEach((data, key) => {
                if (!key.options().visible || (activeSeries.current && key !== activeSeries.current)) return;
                let color = key.options().color || key.options().topFillColor1 || key.options().lineColor || key.options().upColor || key.options().borderColor;
                let value = data.value !== undefined ? data.value : data.close;
                seriesData.push({
                    label_name: key.options().title2,
                    color: color,
                    value: value,
                    time: DateTimeString(
                        data.time,
                        settings.minResolution,
                        settings.dateShift,
                        settings.dateScale,
                    ),
                    x: newChart.timeScale().timeToCoordinate(data.time),
                    y: key.priceToCoordinate(value),
                })
            });

            const { point } = param;
            if (!point || !seriesData.length) {
                tooltipRef.style.opacity = '0';
                return;
            }

            let tooltipHTML = '';
            seriesData.forEach(data => {
                tooltipHTML += `
                    <div class="tooltip">
                        <div class="cube" style="background: ${data.color}"></div>
                        <div>${settings.tooltipFormat.replace(/\${(.*?)}/g, (_, key) => data[key.trim()] ?? 0)}</div>
                    </div>
                `;
            });
            
            const chartRect = ref.current?.getBoundingClientRect();
            if (tooltipRef) tooltipRef.style.opacity = '0';
            if (tooltipHTML && tooltipRef && chartRect && param?.sourceEvent?.pageX) {
                tooltipRef.innerHTML  = tooltipHTML;
                if (window.innerWidth - param?.sourceEvent?.pageX < tooltipRef.offsetWidth) {
                    tooltipRef.style.left = `${param?.sourceEvent?.pageX - tooltipRef.offsetWidth - 10}px`;
                } else {
                    tooltipRef.style.left = `${param?.sourceEvent?.pageX + 10}px`;
                }
                if (window.innerHeight - param?.sourceEvent?.pageY < tooltipRef.offsetHeight) {
                    tooltipRef.style.top  = `${param?.sourceEvent?.pageY - window.scrollY - tooltipRef.offsetHeight - 15}px`;
                } else  {
                    tooltipRef.style.top  = `${param?.sourceEvent?.pageY - window.scrollY - 15}px`;
                }
                tooltipRef.style.opacity = '1';
            };
        }), 200);

        const handleResize = debounce(() => {
            if (newChart) {
                newChart.applyOptions({ width: ref.current.clientWidth, height: ref.current.clientHeight - 1 });
            }
        }, 0);

        const resizeObserver = new ResizeObserver(handleResize);
        resizeObserver.observe(ref.current);

        setPanel(newChart);
        setPanels((state) => [...state, newChart]);
        createSeriesMap(newChart);
        setMarginLabels(150);
    };

    const setMarginLabels = (timeout) => {
        if (!ref.current?.previousSibling) return;
        setTimeout(() => {
            let offset = ref.current.getElementsByTagName('td')[0]?.clientWidth + 5;
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
                lastValueVisible: settings.lastValueVisible,
                title2: chart.settings.title,
            });

            if (!settings.titleVisible) {
                charts[chart.id].applyOptions({
                    title: "",
                });
            }

            charts[chart.id].applyOptions({
                autoscaleInfoProvider: (original) => {
                    const scaleSettings = original();
                    if (scaleSettings !== null) {
                        let isLeftPriceScaleId = chart.settings.priceScaleId === "left";
                        const minYValue = isLeftPriceScaleId
                            ? (settings.leftMinY ?? settings.minY)
                            : (settings.rightMinY ?? settings.minY);

                        const maxYValue = isLeftPriceScaleId
                            ? (settings.leftMaxY ?? settings.maxY)
                            : (settings.rightMaxY ?? settings.maxY);

                        if (minYValue !== null) {
                            scaleSettings.priceRange.minValue = minYValue;
                        }
                        if (maxYValue !== null) {
                            scaleSettings.priceRange.maxValue = maxYValue;
                        }
                    }
                    return scaleSettings;
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
            };

            if (chart.settings.priceScaleId === 'left' &&chart.settings.visible) {
                visibleLeftScale = true;
            }

            if (chart.settings.priceScaleId === 'right' && chart.settings.visible) {
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

        panel.applyOptions({
            crosshair: settings.crosshairSettings
        });

        setLabels(settings.charts);
        createPlugin(charts, panel);

        panel.subscribeClick((params) => handleClickChart(params));

        chartsSeries.current = charts;
        setLabels(settings.charts);
        createPlugin(charts, panel);

        if (settings.charts.length > 1) sortCharts(settings.charts);
    };

    const createPlugin = (seriesMap, panel) => {
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
                                time: chart.data[plugin.settings.point1.index].time,
                                price: plugin.settings.point1.price,
                            },
                            {
                                time: chart.data[plugin.settings.point2.index].time,
                                price: plugin.settings.point2.price,
                            },
                            plugin.settings
                        );
                        seriesMap[chart.id].attachPrimitive(trend);
                        break;
                    case 'addCrosshairHighlightBar':
                        const highlightPrimitive = new CrosshairHighlightPrimitive(plugin.settings);
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

    function setSeriesHighlight(series, highlight, styleSettings) {
        let options = styleSettings ?? series.options();
        if (series.seriesType() == "Bar") {
            series.applyOptions({
                upColor: highlight ? options.upColor : convertToRGBA(options.upColor, 0.3),
                downColor: highlight ? options.downColor : convertToRGBA(options.downColor, 0.3),
            });
        } else if (series.seriesType() == "Line") {
            series.applyOptions({
                color: highlight ? options.color : convertToRGBA(options.color, 0.3),
                crosshairMarkerBorderColor: highlight ? options.crosshairMarkerBorderColor : convertToRGBA(options.crosshairMarkerBorderColor, 0.3),
                crosshairMarkerBackgroundColor: highlight ? options.crosshairMarkerBackgroundColor : convertToRGBA(options.crosshairMarkerBackgroundColor, 0.3),
            });
        } else if (series.seriesType() == "Candlestick") {
            series.applyOptions({
                upColor: highlight ? options.upColor : convertToRGBA(options.upColor, 0.3),
                downColor: highlight ? options.downColor : convertToRGBA(options.downColor, 0.3),
                borderColor: highlight ? options.borderColor : convertToRGBA(options.borderColor, 0.3),
                borderUpColor: highlight ? options.borderUpColor : convertToRGBA(options.borderUpColor, 0.3),
                borderDownColor: highlight ? options.borderDownColor : convertToRGBA(options.borderDownColor, 0.3),
                wickColor: highlight ? options.wickColor : convertToRGBA(options.wickColor, 0.3),
                wickUpColor: highlight ? options.wickUpColor : convertToRGBA(options.wickUpColor, 0.3),
                wickDownColor: highlight ? options.wickDownColor : convertToRGBA(options.wickDownColor, 0.3),
            });
        } else if (series.seriesType() == "Area") {
            series.applyOptions({
                topColor: highlight ? options.topColor : convertToRGBA(options.topColor, 0.3),
                bottomColor: highlight ? options.bottomColor : convertToRGBA(options.bottomColor, 0.1),
                lineColor: highlight ? options.lineColor : convertToRGBA(options.lineColor, 0.3),
                crosshairMarkerBorderColor: highlight ? options.crosshairMarkerBorderColor : convertToRGBA(options.crosshairMarkerBorderColor, 0.3),
                crosshairMarkerBackgroundColor: highlight ? options.crosshairMarkerBackgroundColor : convertToRGBA(options.crosshairMarkerBackgroundColor, 0.3),
            });
        } else if (series.seriesType() == "Baseline") {
            series.applyOptions({
                topLineColor: highlight ? options.topLineColor : convertToRGBA(options.topLineColor, 0.1),
                topFillColor1: highlight ? options.topFillColor1 : convertToRGBA(options.topFillColor1, 0.1),
                topFillColor2: highlight ? options.topFillColor2 : convertToRGBA(options.topFillColor2, 0.05),
                bottomLineColor: highlight ? options.bottomLineColor : convertToRGBA(options.bottomLineColor, 0.1),
                bottomFillColor1: highlight ? options.bottomFillColor1 : convertToRGBA(options.bottomFillColor1, 0.1),
                bottomFillColor2: highlight ? options.bottomFillColor2 : convertToRGBA(options.bottomFillColor2, 0.05),
            });
        }
    }
    
    function resetSeriesHighlight(charts) {
        Object.entries(charts).forEach(([chartId, series]) => {
            setSeriesHighlight(series, true, styleSettings.current[chartId]);
        });
        activeSeries.current = null;
    }

    function highlightSeries(currentSeries, charts) {
        Object.entries(charts).forEach(([chartId, series]) => {
            if (series === currentSeries) setSeriesHighlight(series, true, styleSettings.current[chartId]) 
            else setSeriesHighlight(series, false, styleSettings.current[chartId]);
        });
        activeSeries.current = currentSeries;
    }

    const sortSeries = (param) => {
        const seriesByDistance = [];
        param.seriesData.forEach((value, serie, map)=> {
            let refPrice = undefined;
            const serieType = serie.seriesType();
            if (serieType == 'Line') {
              refPrice = value.value;
            } else if (serieType == 'Candlestick') {
                refPrice = value.close;
            } else if (serieType == 'Histogram') {
                refPrice = value.value;
            } else if (serieType == 'Area') {
                refPrice = value.value;
            } else if (serieType == 'Bar') {
                refPrice = value.close;
            } else if (serieType == 'Baseline') {
                refPrice = value.value;
            }
            if(refPrice != undefined) {
                const distance = param.point.y - serie.priceToCoordinate(refPrice);
                seriesByDistance.push({
                    'distance': Math.abs(distance),
                    'serie': serie,
                });
            }
        });
        seriesByDistance.sort((a, b) => a.distance - b.distance);
        return seriesByDistance;
    }
    
    const handleClickChart = (param) => {
        if (!param.sourceEvent.metaKey && !param.sourceEvent.ctrlKey) {
            activeSeries.current && resetSeriesHighlight(chartsSeries.current); 
            return;
        }
        if (!param || !param.seriesData || param.seriesData.length === 0) {
            activeSeries.current && resetSeriesHighlight(chartsSeries.current); 
            return;
        }
        if (!param.seriesData.size) {
            activeSeries.current && resetSeriesHighlight(chartsSeries.current);
            return;
        }
        const seriesByDistance = sortSeries(param);
        if (seriesByDistance[0].distance <= 10) {
            highlightSeries(seriesByDistance[0].serie, chartsSeries.current);
        } else {
            activeSeries.current && resetSeriesHighlight(chartsSeries.current);
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

    const handleFullScreen = (e) => {
        e.stopPropagation();
        panelRef.current?.classList.toggle("fullscreen");
        setFullscreen(state => !state);
    };

    const toogleTool = () => {
        setOpenTool(state => !state);
    };

    const legendButtonClass = useMemo(() => {
        return openTool ? "grid-item-button selected" : "grid-item-button";
    }, [openTool]);
    
    return (
        <div className="grid-item" ref={panelRef}>
             <div className='grid-item-header draggable-handle'>
                <div className='grid-item-name'><span>{settings.name}</span></div>
                <div className='grid-item-buttons draggable-сancel'>
                   {settings.legendMode == "table" && (
                        <div className={legendButtonClass} onMouseDown={toogleTool}>
                            <svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" width="14" height="14"><path d="M10.5334 24.3539C10.8787 24.1232 11.2848 24 11.7001 24C12.2571 24 12.7912 24.2212 13.185 24.6151C13.5788 25.0089 13.8001 25.543 13.8001 26.1C13.8001 26.5153 13.6769 26.9214 13.4462 27.2667C13.2154 27.612 12.8875 27.8812 12.5037 28.0401C12.12 28.1991 11.6978 28.2407 11.2904 28.1596C10.883 28.0786 10.5089 27.8786 10.2152 27.5849C9.92148 27.2912 9.72148 26.917 9.64045 26.5097C9.55942 26.1023 9.60101 25.6801 9.75995 25.2964C9.9189 24.9126 10.1881 24.5847 10.5334 24.3539Z"></path><path d="M36.3001 28.2L20.1001 28.2C19.5431 28.2 19.009 27.9787 18.6152 27.5849C18.2213 27.1911 18.0001 26.657 18.0001 26.1C18.0001 25.543 18.2213 25.0089 18.6152 24.6151C19.009 24.2212 19.5431 24 20.1001 24L36.3001 24C36.857 24 37.3912 24.2212 37.785 24.6151C38.1788 25.0089 38.4001 25.543 38.4001 26.1C38.4001 26.657 38.1788 27.1911 37.785 27.5849C37.3912 27.9787 36.857 28.2 36.3001 28.2Z"></path><path d="M10.5334 33.954C10.8787 33.7233 11.2848 33.6001 11.7001 33.6001C12.2571 33.6001 12.7912 33.8213 13.185 34.2152C13.5788 34.609 13.8001 35.1431 13.8001 35.7001C13.8001 36.1154 13.6769 36.5215 13.4462 36.8668C13.2154 37.2121 12.8875 37.4813 12.5037 37.6402C12.12 37.7992 11.6978 37.8408 11.2904 37.7597C10.883 37.6787 10.5089 37.4787 10.2152 37.185C9.92148 36.8913 9.72148 36.5171 9.64045 36.1098C9.55942 35.7024 9.60101 35.2802 9.75995 34.8965C9.9189 34.5127 10.1881 34.1848 10.5334 33.954Z"></path><path d="M36.3001 37.8001L20.1001 37.8001C19.5431 37.8001 19.009 37.5788 18.6152 37.185C18.2213 36.7912 18.0001 36.2571 18.0001 35.7001C18.0001 35.1431 18.2213 34.609 18.6152 34.2152C19.009 33.8213 19.5431 33.6001 20.1001 33.6001L36.3001 33.6001C36.857 33.6001 37.3912 33.8213 37.785 34.2152C38.1788 34.609 38.4001 35.1431 38.4001 35.7001C38.4001 36.2571 38.1788 36.7912 37.785 37.185C37.3912 37.5788 36.857 37.8001 36.3001 37.8001Z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M40.8 4.8H7.2C5.87452 4.8 4.8 5.87452 4.8 7.2V40.8C4.8 42.1255 5.87452 43.2 7.2 43.2H40.8C42.1255 43.2 43.2 42.1255 43.2 40.8V7.2C43.2 5.87452 42.1255 4.8 40.8 4.8ZM7.2 0C3.22355 0 0 3.22355 0 7.2V40.8C0 44.7765 3.22355 48 7.2 48H40.8C44.7765 48 48 44.7765 48 40.8V7.2C48 3.22355 44.7765 0 40.8 0H7.2Z"></path></svg>
                        </div>
                    )}
                    <div className="grid-item-button draggable-сancel" onMouseDown={handleFullScreen}>
                    {
                        fullscreen
                        ? <svg viewBox="0 0 24 24" width={16} height={16} xmlns="http://www.w3.org/2000/svg"><path d="M4.621 21.5l3.44-3.439 3.439 3.44v-9h-9l3.44 3.439-3.44 3.44 2.121 2.12zM12.5 2.5l3.44 3.44 3.439-3.44L21.5 4.622l-3.44 3.44L21.5 11.5h-9v-9z" fill="#5f6368"></path></svg>
                        : <svg viewBox="0 0 24 24" width={16} height={16} xmlns="http://www.w3.org/2000/svg"><path d="M14.121 12l3.44-3.44L21 12V3h-9l3.44 3.44L12 9.878l2.121 2.12zM3 12l3.44 3.44L9.878 12 12 14.12l-3.44 3.44L12 21H3v-9z" fill="#5f6368"></path></svg>
                    }                    
                    </div>
                </div>
            </div>
            <div className="grid-area draggable-сancel" style={{cursor: settings.cursor}}>
                {settings.legendMode == "list" && <Label
                    panelId={panelId}
                    labels={labels}
                    minChartsForSearch={settings.minChartsForSearch}
                    defaultVisible={settings.defaultLegendVisible}
                    charts={chartsSeries.current}
                    panel={panel}
                    searchLabel={searchLabel}
                    setMarginLabels={setMarginLabels}
                />}
                <div className="charts" ref={ref}></div>
                {settings.legendMode == "table" && <ChartsManager
                    openTool={openTool}
                    panelId={panelId}
                    labels={labels}
                    charts={chartsSeries.current}
                    defaultVisible={settings.defaultLegendVisible}
                    panel={panel}
                    setMarginLabels={setMarginLabels}
                />}
            </div>
            <div ref={tooltip} className='line-series-tooltip' />
        </div>
    );
};

export default ChartPanel;
