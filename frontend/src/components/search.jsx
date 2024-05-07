import React from 'react';
import { useState } from 'react';

const Search = ({ panelId, onChange }) => {
    const [search, setSearch] = useState('');

    return (
        <div id={`search${panelId}`} className="searchs">
            <input
                id={`chartsearch${panelId}`}
                className="chartsearch"
                type="text"
                placeholder="search"
                spellCheck={false}
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                onKeyUp={() => onChange(search)}
            />
        </div>
    );
};

export default Search;
