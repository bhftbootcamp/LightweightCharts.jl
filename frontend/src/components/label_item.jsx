import React from 'react';

function LabelItem({ panelId, id, labelColor, labelName, onClick, hideAll }) {
    return (
        <div
            id={`label${panelId}${id}`}
            className={`label-item ${!hideAll ? 'hide-chart' : ''}`}
            onClick={(e) => onClick(e, id)}>
            <div className="label">
                <div className="cube" style={{ background: labelColor }}></div>
                <div className="name" data-label-name={`${labelName}`}>
                    {labelName}
                </div>
            </div>
        </div>
    );
}

export default LabelItem;
