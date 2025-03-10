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
    const [sortConfig, setSortConfig] = useState({ key: 'name', direction: 'asc' });
    const selected = useRef(new Set([]));
    const hidden = useRef(new Set([]));

    const toolLabels = useMemo(() => {
        let computedLabels = labels.map((label) => {
            const firstValue = label.data[0].value;
            const lastValue = label.data[label.data.length - 1].value;
            const maxValue = Math.max(...label.data.map(d => d.value));
            const minValue = Math.min(...label.data.map(d => d.value));
            return {
                id: label.id,
                labelColor: label.labelColor,
                labelName: label.labelName,
                first: firstValue,
                last: lastValue,
                max: maxValue,
                min: minValue
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
            if (prev.key === key) {
                return { key, direction: prev.direction === 'asc' ? 'desc' : 'asc' };
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

    return (
        <div style={{width: !openTool ? "0px": "auto", position: "relative"}}>
            <Resizable
                defaultSize={{ width: 500, height: "100%" }}
                maxWidth={1000}
                minWidth={410}
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
                                    <th>
                                        <div onClick={() => handleSort('labelName')}>Name</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig.key == "labelName" && sortConfig.direction == 'asc' ? asc : sortConfig.key == "labelName" && sortConfig.direction == 'desc' && desc}</div>
                                    </th>
                                    <th>
                                        <div onClick={() => handleSort('first')}>First</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig.key == "first" && sortConfig.direction == 'asc' ? asc : sortConfig.key == "first" && sortConfig.direction == 'desc' && desc}</div>
                                    </th>
                                    <th>
                                        <div onClick={() => handleSort('min')}>Min</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig.key == "min" && sortConfig.direction == 'asc' ? asc : sortConfig.key == "min" && sortConfig.direction == 'desc' && desc}</div>
                                    </th>
                                    <th>
                                        <div onClick={() => handleSort('max')}>Max</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig.key == "max" && sortConfig.direction == 'asc' ? asc : sortConfig.key == "max" && sortConfig.direction == 'desc' && desc}</div>
                                    </th>
                                    <th>
                                        <div onClick={() => handleSort('last')}>Last</div>
                                        <div style={{marginTop: "4px"}}>{sortConfig.key == "last" && sortConfig.direction == 'asc' ? asc : sortConfig.key == "last" && sortConfig.direction == 'desc' && desc}</div>
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
