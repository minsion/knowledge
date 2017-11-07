let path = require('path');
let webpack = require('webpack');
let HtmlWebpackPlugin = require('html-webpack-plugin');
module.exports = {
	entry:{
	main:'./src/script/main.js',
	a:'./src/script/a.js'
	},
	output:{
		path:path.resolve(__dirname,'./dist'),
		filename:'js/[name].js',
		publicPath:'http://cdn.com/'
	},
	plugins:[
		new HtmlWebpackPlugin({
			filename:'index.html',
			template:'index.html',
			inject:false,
			title:'this is my first webpack project!',
			minify:{
				removeComments:true,
				collapseWhitespace:true
			}
		})
	]
}