const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
    mode: 'development',
    entry: "./src/index.jsx",
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].js',
    },
    module:{
        rules:[
            {
                test: /\.(jsx|ts)$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [
                            '@babel/preset-env', 
                            '@babel/preset-react',
                            '@babel/preset-typescript'
                        ],
                    }
                }
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            }
        ]
    },
    devServer: {
        port: 3000,
        static: {
            directory: path.join(__dirname, 'dist'),
        },
        historyApiFallback: {
            rewrites: [
              { from: /^\/ex1/, to: '/01_line_baseline.html' },
              { from: /^\/ex2/, to: '/02_scatter_line.html' },
              { from: /^\/ex3/, to: '/03_trend_line.html' },
              { from: /^\/ex4/, to: '/04_tooltip.html' },
            ]
        },
        liveReload: true,
        hot: false,
        watchFiles: ["src/*"],
        client: {
            webSocketTransport: 'ws',
        },
        webSocketServer: 'ws',
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: "./public/index.html"
        }),
        new HtmlWebpackPlugin({
            template: "./public/01_line_baseline.html",
            filename: "01_line_baseline.html",
        }),
        new HtmlWebpackPlugin({
            template: "./public/02_scatter_line.html",
            filename: "02_scatter_line.html",
        }),
        new HtmlWebpackPlugin({
            template: "./public/03_trend_line.html",
            filename: "03_trend_line.html",
        }),
        new HtmlWebpackPlugin({
            template: "./public/04_tooltip.html",
            filename: "04_tooltip.html",
        }),
    ]
}
