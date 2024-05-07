import React, { useEffect, useRef } from 'react';

const Copyright = ({ chart }) => {
    const div = useRef(null);

    useEffect(() => {
        setTimeout(() => {
            let offset =
                chart.current.getElementsByTagName('td')[0]?.clientWidth + 10;
            let height =
                chart.current.getElementsByTagName('tr')[1]?.clientHeight + 10;
            div.current.style.left = offset + 'px';
            div.current.style.bottom = height + 'px';
        }, 150);
    }, [chart]);

    return (
        <div ref={div} className="copyright-tv">
            <a
                href="https://www.tradingview.com/"
                target="_blank"
                style={{ textDecoration: 'none' }}>
                <span className="logo-tv">
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 22 11"
                        width="22"
                        height="11">
                        <path
                            fill="#131722"
                            d="M9 0H0v4h5v7h4V0Zm8 11h-5l4.5-11h5L17 11Zm-5-7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"></path>
                    </svg>
                </span>

                <span className="shield-tv">Chart by TradingView</span>
            </a>
        </div>
    );
};

export default Copyright;
