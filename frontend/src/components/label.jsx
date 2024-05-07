import React, { useRef } from 'react';
import { useState } from 'react';

import Search from './search.jsx';
import LabelItem from './label_item.jsx';

function Label({
    panelId,
    minChartsForSearch,
    labels,
    charts,
    panel,
    searchLabel,
    setMarginLabels,
}) {
    const [hideAll, setHideAll] = useState(true);
    const ref = useRef(null);

    const showLabels = (event) => {
        event.currentTarget?.classList.toggle('svg-rotate');
        event.currentTarget?.previousSibling.classList.toggle('unshow-label');
    };

    const hideAllCharts = (event) => {
        let hide = document.getElementById(`hide${panelId}`);

        if (hideAll) {
            hide.classList.add('hide-chart');
        } else {
            hide.classList.remove('hide-chart');
        }

        let visibleLeftScale = false;
        let visibleRightScale = false;

        for (let id in charts) {
            charts[id].applyOptions({
                visible: hideAll ? false : true,
            });

            if (
                charts[id].options().priceScaleId === 'left' &&
                charts[id].options().visible
            ) {
                visibleLeftScale = true;
            }

            if (
                charts[id].options().priceScaleId === 'right' &&
                charts[id].options().visible
            ) {
                visibleRightScale = true;
            }
        }

        panel.applyOptions({
            leftPriceScale: {
                visible: !hideAll && visibleLeftScale,
            },
            rightPriceScale: {
                visible: !hideAll && visibleRightScale,
            },
        });
        setHideAll((state) => !state);
        setMarginLabels(50);
    };

    const hideChart = (event, chart_id) => {
        let visible = true ^ charts[chart_id].options().visible;

        charts[chart_id].applyOptions({
            visible: visible,
        });

        if (visible) {
            event.currentTarget?.classList.remove('hide-chart');
        } else {
            event.currentTarget?.classList.add('hide-chart');
        }

        if (Object.keys(charts).length > 1) {
            let visibleHideAll = true;
            let visibleLeftScale = false;
            let visibleRightScale = false;

            for (let id in charts) {
                let visible_chart = true ^ charts[id].options().visible;
                if (!visible_chart) {
                    visibleHideAll = false;
                }

                if (
                    charts[id].options().priceScaleId === 'left' &&
                    charts[id].options().visible
                ) {
                    visibleLeftScale = true;
                }

                if (
                    charts[id].options().priceScaleId === 'right' &&
                    charts[id].options().visible
                ) {
                    visibleRightScale = true;
                }
            }

            let hide = document.getElementById(`hide${panelId}`);

            if (visibleHideAll) {
                hide.classList.add('hide-chart');
            } else {
                hide.classList.remove('hide-chart');
            }

            panel.applyOptions({
                leftPriceScale: {
                    visible: visibleLeftScale,
                },
                rightPriceScale: {
                    visible: visibleRightScale,
                },
            });
        };
        setMarginLabels(50);
    };

    return (
        <div id={`tabs${panelId}`} className="tabs" ref={ref}>
            <div id={`labels${panelId}`} className="labels">
                {Object.keys(charts).length > minChartsForSearch ? (
                    <Search panelId={panelId} onChange={searchLabel} />
                ) : (
                    <></>
                )}
                {Object.keys(charts).length > 1 ? (
                    <div
                        id={`hide${panelId}`}
                        className="label-item"
                        onClick={hideAllCharts}>
                        <div className="label">
                            <div
                                className="cube"
                                style={{ background: 'black' }}></div>
                            <div className="name">all</div>
                        </div>
                    </div>
                ) : (
                    <></>
                )}
                {labels &&
                    labels.map((chart) => {
                        return (
                            <LabelItem
                                key={chart.id}
                                id={chart.id}
                                panelId={panelId}
                                labelColor={chart.labelColor}
                                labelName={chart.labelName}
                                hideAll={hideAll}
                                onClick={hideChart}
                            />
                        );
                    })}
            </div>
            <div id={'btn'} className="btn" onClick={showLabels}>
                <svg
                    className="btn-icon svg-rotate"
                    width="10"
                    height="10"
                    viewBox="0 0 34 30"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M2 5L16.5038 19.2979C16.8971 19.6856 17.5303 19.6811 17.918 19.2877L32 5"
                        stroke="black"
                        strokeWidth="3"
                    />
                </svg>
            </div>
        </div>
    );
}

export default Label;
