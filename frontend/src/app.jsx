import React from 'react';
import ChartLayout from './components/charts_layout.jsx';
import './app.css';

function App() {
    const layout = JSON.parse(json_layout);
    const root = document.getElementById('root');
    root.style.minHeight = layout.minHeight + "px";
    window.document.title = layout.name;

    console.log(layout);
    return <ChartLayout layout={{ ...layout }} />;
}

export default App;
