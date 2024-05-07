import React, { useEffect, useMemo, useState } from 'react';
import ChartPanel from './chart_panel.jsx';
import { lcm } from '../helpers/utils.ts';

const ChartLayout = ({ layout }) => {
    const [panels, setPanels] = useState([]);

    const grid = useMemo(() => {
        const initPanels = Object.values(layout.panels);
        const setX = new Set(initPanels.map((panel) => panel.x));
        const setY = new Set(initPanels.map((panel) => panel.y));

        const maxX = [...setX].reduce(lcm);
        const maxY = setY.size;

        const areas = Array.from({ length: maxY }, () =>
            new Array(maxX).fill('')
        );

        for (let column = 0; column < maxY; column++) {
            const cols = initPanels.filter(
                (panel) => panel.y === column + 1
            ).length;
            const step = Math.floor(maxX / cols);
            let iden = 1;

            for (let index = 0; index < maxX; index++) {
                const cell = `cell${iden}${column + 1}`;
                areas[column][index] = cell;

                if ((index + 1) % step === 0 && iden < cols) {
                    iden++;
                }
            }
        }

        const gridTemplateAreas = areas
            .map((row) => `'${row.join(' ')}'`)
            .join('\n');
        const gridTemplateRows = Array(maxY)
            .fill(`${100 / maxY}vh`)
            .join(' ');
        const gridTemplateColumns = Array(maxX)
            .fill(`${100 / maxX}%`)
            .join(' ');

        return {
            gridTemplateAreas,
            gridTemplateRows,
            gridTemplateColumns,
        };
    }, [layout]);

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
        <div
            className="grid-layout"
            style={{
                gridTemplateAreas: grid.gridTemplateAreas,
                gridTemplateColumns: grid.gridTemplateColumns,
                gridTemplateRows: grid.gridTemplateRows,
            }}>
            {Object.keys(layout.panels).map((panel) => {
                return (
                    <ChartPanel
                        key={panel}
                        settings={layout.panels[panel]}
                        setPanels={setPanels}
                        id={panel}
                    />
                );
            })}
        </div>
    );
};

export default ChartLayout;
