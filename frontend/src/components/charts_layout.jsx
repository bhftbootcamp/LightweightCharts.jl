import React, { useEffect, useMemo, useState } from 'react';
import ChartPanel from './chart_panel.jsx';
import { lcm } from '../helpers/utils.ts';
import '/node_modules/react-grid-layout/css/styles.css';
import '/node_modules/react-resizable/css/styles.css';
import RGL, { WidthProvider } from "react-grid-layout";

const ResponsiveReactGridLayout = WidthProvider(RGL);

const ChartLayout = ({ layout }) => {
    const [panels, setPanels] = useState([]);

    const rowCounts = useMemo(() => {
        const rowMap = {};
        Object.values(layout.panels).forEach((panel) => {
            if (!rowMap[panel.y]) {
                rowMap[panel.y] = 0;
            }
            rowMap[panel.y] += 1;
        });
        return rowMap;
    }, [layout.panels]);

    const colCounts = useMemo(() => {
        const initPanels = Object.values(layout.panels);
        const setX = new Set(initPanels.map((panel) => panel.x));

        const maxX = [...setX].reduce(lcm);
        return maxX * 12;
    }, [layout.panels]);


    const rowHeight = useMemo(() => {
        return (window.innerHeight - 8) / 100; 
    }, []);


    const gridLayout = useMemo(() => {
        return Object.entries(layout.panels).map(([key, panel]) => {
            const countInRow = rowCounts[panel.y] || 1;
            return {
                i: key,
                x: (panel.x - 1) * Math.floor(colCounts / countInRow) || 0,
                y: (panel.y - 1) || 0,
                w: Math.floor(colCounts / countInRow),
                h: panel.h  * 100
            };
        });
    }, [rowCounts, colCounts]);

    useEffect(() => {
        if (layout.sync) {
            for (const panelOut of panels) {
                panelOut
                    ?.timeScale()
                    .subscribeVisibleLogicalRangeChange((that) => {
                        for (const panelIn of panels) {
                            if (that != null) {
                                panelIn?.timeScale().setVisibleLogicalRange({
                                    from: that.from,
                                    to: that.to,
                                });
                            }
                        }
                    });
            }
        }
    }, [panels]);

    return (
        <ResponsiveReactGridLayout
            className="grid-layout"
            layout={gridLayout}
            cols={colCounts}
            rowHeight={rowHeight} 
            margin={[0, 0]}
            containerPadding={[4, 4]}
            isResizable={layout.resizable}
            useCSSTransforms={false}
            draggableCancel='.draggable-сancel'
            draggableHandle='.draggable-handle'
        >
            {gridLayout.map((panel) => (
                <div key={panel.i} data-grid={panel} style={{padding: "4px"}}>
                    <ChartPanel
                        settings={layout.panels[panel.i]}
                        setPanels={setPanels}
                        id={panel.i}
                    />
                </div>
            ))}
        </ResponsiveReactGridLayout>
    );
};

export default ChartLayout;
