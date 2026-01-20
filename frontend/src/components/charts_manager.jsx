import React, { useMemo, useRef, useState } from 'react';
import ToolItem from './tool_item.jsx';
import { Resizable } from 're-resizable';

function ChartsManager({
    openTool,
    panelId,
    labels,
    charts,
    panel,
    setMarginLabels,
}) {
    const [sortConfig, setSortConfig] = useState(null);
    const selected = useRef(new Set([]));
    const hidden = useRef(new Set([]));

    const toolLabels = useMemo(() => {
        let computedLabels = labels.map((label) => {
            const firstValue = label.data[0].value;
            const lastValue = label.data[label.data.length - 1].value;
            const maxValue = Math.max(...label.data.map(d => d.value));
            const minValue = Math.min(...label.data.map(d => d.value));
            const diffValue = lastValue - firstValue;
            return {
                id: label.id,
                labelColor: label.labelColor,
                labelName: label.labelName,
                first: firstValue,
                last: lastValue,
                max: maxValue,
                min: minValue,
                diff: diffValue
            };
        });
        if (sortConfig !== null) {
            computedLabels.sort((a, b) => {
                if (a[sortConfig.key] < b[sortConfig.key]) {
                    return sortConfig.direction === 'asc' ? -1 : 1;
                }
                if (a[sortConfig.key] > b[sortConfig.key]) {
                    return sortConfig.direction === 'asc' ? 1 : -1;
                }
                return 0;
            });
        };

        return computedLabels;
    }, [labels, sortConfig]);

    const selectChart = (event, chart_id) => {
        event.preventDefault();
        if (!event.shiftKey) {
            if (selected.current.has(chart_id)) selected.current = new Set()
            else selected.current = new Set([chart_id]);
            hidden.current = new Set([]);
        } else {
            if (selected.current.size != 0) {
                selected.current.has(chart_id) ? selected.current.delete(chart_id): selected.current.add(chart_id);
                hidden.current = new Set([]);
            } else {
                hideChart(event, chart_id);
                return;
            }
        }

        for (let id in charts) {
            let visible = selected.current.size == 0 && !event.shiftKey ? true : selected.current.has(Number(id));
            charts[Number(id)].applyOptions({ visible: visible });
            let el = document.getElementById(`tool${panelId}${id}`);
            if (!visible) {
                el?.classList.add('hide-chart');
            } else {
                el?.classList.remove('hide-chart');
            }
        }

        if (selected.current.size == 0 && event.shiftKey) {
            document.getElementById(`table${panelId}`)?.classList.remove('hide-all');
        } else {
            document.getElementById(`table${panelId}`)?.classList.remove('hide-all');
        }

        if (Object.keys(charts).length > 1) {
            let visibleLeftScale = false;
            let visibleRightScale = false;

            for (let id in charts) {
                if (charts[id].options().priceScaleId === 'left' && charts[id].options().visible) {
                    visibleLeftScale = true;
                }
                if (charts[id].options().priceScaleId === 'right' && charts[id].options().visible) {
                    visibleRightScale = true;
                }
            }
            
            panel.applyOptions({
                leftPriceScale: { visible: visibleLeftScale },
                rightPriceScale: { visible: visibleRightScale },
            });
        };
        setMarginLabels(50);
    };

    const hideChart = (event, chart_id) => {
        hidden.current.has(chart_id) ? hidden.current.delete(chart_id) : hidden.current.add(chart_id);

        for (let id in charts) {
            let visible = !hidden.current.has(Number(id));
            charts[Number(id)].applyOptions({ visible: visible });
            let el = document.getElementById(`tool${panelId}${id}`);
            if (!visible) {
                el?.classList.add('hide-chart');
            } else {
                el?.classList.remove('hide-chart');
            }
        }

        if (Object.keys(charts).length > 1) {
            let visibleLeftScale = false;
            let visibleRightScale = false;

            for (let id in charts) {
                if (charts[id].options().priceScaleId === 'left' && charts[id].options().visible) {
                    visibleLeftScale = true;
                }
                if (charts[id].options().priceScaleId === 'right' && charts[id].options().visible) {
                    visibleRightScale = true;
                }
            }
            
            panel.applyOptions({
                leftPriceScale: { visible: visibleLeftScale },
                rightPriceScale: { visible: visibleRightScale },
            });
        };
        setMarginLabels(50);
    };

    const handleSort = (key) => {
        setSortConfig((prev) => {
            if (prev?.key === key) {
                let direction = prev.direction === 'asc' ? 'desc' : prev.direction === 'desc' ? null : 'asc';
                if (!direction) return null;
                return { key, direction };
            }
            return { key, direction: 'asc' };
        });
    };

    const desc = (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="12" height="12"><path d="M17,9.17a1,1,0,0,0-1.41,0L12,12.71,8.46,9.17a1,1,0,0,0-1.41,0,1,1,0,0,0,0,1.42l4.24,4.24a1,1,0,0,0,1.42,0L17,10.59A1,1,0,0,0,17,9.17Z"></path></svg>
    );

    const asc = (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="12" height="12"><path d="M17,13.41,12.71,9.17a1,1,0,0,0-1.42,0L7.05,13.41a1,1,0,0,0,0,1.42,1,1,0,0,0,1.41,0L12,11.29l3.54,3.54a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29A1,1,0,0,0,17,13.41Z"></path></svg>
    );

    const tooltip = (
        <span
            title="Last - First"
        >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true" width="14" height="14" className="css-1d3xu67-Icon">
                <path d="M11.29,15.29a1.58,1.58,0,0,0-.12.15.76.76,0,0,0-.09.18.64.64,0,0,0-.06.18,1.36,1.36,0,0,0,0,.2.84.84,0,0,0,.08.38.9.9,0,0,0,.54.54.94.94,0,0,0,.76,0,.9.9,0,0,0,.54-.54A1,1,0,0,0,13,16a1,1,0,0,0-.29-.71A1,1,0,0,0,11.29,15.29ZM12,2A10,10,0,1,0,22,12,10,10,0,0,0,12,2Zm0,18a8,8,0,1,1,8-8A8,8,0,0,1,12,20ZM12,7A3,3,0,0,0,9.4,8.5a1,1,0,1,0,1.73,1A1,1,0,0,1,12,9a1,1,0,0,1,0,2,1,1,0,0,0-1,1v1a1,1,0,0,0,2,0v-.18A3,3,0,0,0,12,7Z"></path>
            </svg>
        </span>
    )

    return (
        <div style={{width: !openTool ? "0px": "auto", position: "relative"}}>
            <Resizable
                defaultSize={{ width: 520, height: "100%" }}
                maxWidth={1000}
                minWidth={200}
                enable={{
                    right: false,
                    left:  true,
                    bottom: false,
                    top: false
                }}
                className='relative'
                style={{
                    display: !openTool ? "none" : "block",
                    width: !openTool ? "0px": "300px"
                }}
            >
                <div id={`chart-tool${panelId}`} className="chart-tool">
                    <div id={`labels${panelId}`} className={`labels`}>
                        <table className="tool-table" id={`table${panelId}`}>
                            <thead>
                                <tr className="label-header">
                                    <th onClick={() => handleSort('labelName')}>
                                        <div className="cube" style={{marginRight: "12px"}}></div>
                                        <div>Name</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "labelName" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "labelName" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                    <th onClick={() => handleSort('first')}>
                                        <div>First</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "first" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "first" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                    <th onClick={() => handleSort('min')}>
                                        <div>Min</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "min" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "min" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                    <th onClick={() => handleSort('max')}>
                                        <div>Max</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "max" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "max" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                    <th onClick={() => handleSort('last')}>
                                        <div>Last</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "last" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "last" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                    <th onClick={() => handleSort('diff')}>
                                        <div>ΔLF</div>
                                        <div style={{marginLeft: "4px"}}>{tooltip}</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig?.key == "diff" && sortConfig?.direction == 'asc' ? asc : sortConfig?.key == "diff" && sortConfig?.direction == 'desc' && desc}</div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                {toolLabels.map((tool) => (
                                    <ToolItem key={tool.id} panelId={panelId} tool={tool} onClick={selectChart}/>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </Resizable>
        </div>
    );
}

export default ChartsManager;
