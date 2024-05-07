const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
   
module.exports = {
    mode: 'production', 
    entry: "./src/index.jsx", 
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'index_boundle.js',
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
    plugins: [
        new HtmlWebpackPlugin({
            template: "./public/index.html"
        }),
    ]
}
