import React from 'react';

function ToolItem({ panelId, tool, onClick }) {
    const formatter = Intl.NumberFormat("en-US", { notation: 'compact', compactDisplay: "short", minimumFractionDigits: 3, maximumFractionDigits: 3, style: "decimal" });
    
    return (
        <tr id={`tool${panelId}${tool.id}`} className="label-item" onClick={(e) => onClick(e, tool.id)}>
            <td>
                <div className='label-name'>
                    <div className="cube" style={{ background: tool.labelColor }}></div>
                    <div style={{ overflow: "hidden", whiteSpace: "nowrap", textOverflow: "ellipsis", userSelect: "none",}}>{tool.labelName}</div>
                </div>
            </td>
            <td>{formatter.format(tool.first)}</td>
            <td>{formatter.format(tool.min)}</td>
            <td>{formatter.format(tool.max)}</td>
            <td>{formatter.format(tool.last)}</td>
        </tr>
    );
}

export default ToolItem;
