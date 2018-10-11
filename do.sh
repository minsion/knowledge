#!/bin/bash
set -o errexit

echo -e "0.创建基础类[pure]\n1.创建页面[page]\n2.创建模块[mod]\n3.创建入口[entry]\n4.启动webpack服务[webpack]\n5.编译[build]\n6.服务[server]\n7.拉取合并[pull]\n8.打包上传[git]\n9.日常上传[daily]\n10.上线上传[online]\n11.创建服务模块[modserver]\n12.创建tag\n13.创建分支"
echo -n "输入你想要的操作:"
read type

if [[ $type -le 14 && $type -ge 0 ]]; then
	doArr=(pure page mod entry webpack build server pull git daily online modserver createTag createBranch)
	type=${doArr[type]}
fi

pureDO(){
	echo -n "初始化还是删除[init|remove](默认init):"
	read init
	[ ! $init ] && init="init"
	echo -n "输入名称:"
	read modame
	if [ $init == "init" ]; then
		echo -n "是否覆盖[false|true](默认false):"
		read isoverwrite
		node mm/$init pure $modame $isoverwrite
	else
		node mm/$init pure $modame
	fi
}

gitDO(){
	branch=`git symbolic-ref --short -q HEAD`
	echo -n "输入注释(默认是add):"
	read commit
	[ ! "$commit" ] && commit="add"
	echo "注释内容:$commit"
	echo "当前分支是${branch}开始推送"
	git add -A
	echo "add √"
	git commit -m "$commit"
	echo "commit √"
	git push origin $branch
	echo "push √"
}

pullDO(){
	branch=`git symbolic-ref --short -q HEAD`
	git pull
	echo "pull √"
	git pull origin $branch
	echo "pull $branch √"
	git status
	echo "status √"
}

mergeDO(){
	branch=`git symbolic-ref --short -q HEAD`
	git add -A
	git commit -m "合并主干暂存"
	git checkout master
	git pull
	git fetch --all
	git reset --hard origin/master
	git checkout branch
	git merge master
}

pageDO(){
	echo -n "初始化还是删除[init|remove](默认init):"
	read init
	[ ! $init ] && init="init"
	echo -n "输入名称:"
	read pagename
	if [ $init == "init" ]; then
		echo -n "是否覆盖[false|true](默认false):"
		read isoverwrite
		node mm/$init page $pagename $isoverwrite
	else
		node mm/$init page $pagename
	fi
}

modDO(){
	echo -n "初始化还是删除[init|remove](默认init):"
	read init
	[ ! $init ] && init="init"
	echo -n "输入名称:"
	read modame
	if [ $init == "init" ]; then
		echo -n "是否覆盖[false|true](默认false):"
		read isoverwrite
		node mm/$init mod $modame $isoverwrite
	else
		node mm/$init mod $modame
	fi
}

entryDO(){
	echo -n "初始化还是删除[init|remove](默认init):"
	read init
	[ ! $init ] && init="init"
	echo -n "输入名称:"
	read entryName
	if [ $init == "init" ]; then
		echo -n "是否覆盖[false|true](默认false):"
		read isoverwrite
		node mm/$init entry $entryName $isoverwrite
	else
		node mm/$init entry $entryName
	fi
}

modserverDO(){
	echo -n "初始化还是删除[init|remove](默认init):"
	read init
	[ ! $init ] && init="init"
	echo -n "输入名称:"
	read modame
	if [ $init == "init" ]; then
		echo -n "是否覆盖[false|true](默认false):"
		read isoverwrite
		node mm/$init server $modame $isoverwrite
	else
		node mm/$init server $modame
	fi
}

webpackDO(){
	echo -n "是否要开启https[false|true](默认false):"
	read isHttps
	[ $isHttps ] && isHttps="--https"
	gulp
	gulp assets
	node_modules/.bin/webpack-dev-server --config ./config/serverConfig.js --hot $isHttps
}

buildDO(){
	gulp --build
	gulp lessAfter
	node_modules/.bin/webpack --config ./config/buildConfig.js --progress --colors
	gulp assets
}

serverDO(){
	echo -n "端口号:(默认3030):"
	read port
	[ ! $port ] && port="3030"
	gulp --build
	gulp lessAfter
	node_modules/.bin/webpack --config ./config/buildConfig.js --progress --colors
	gulp assets
	anywhere $port
}

dailyDO(){
	branch=`git symbolic-ref --short -q HEAD`
	echo -n "输入注释(默认是add):"
	read commit
	[ ! "$commit" ] && commit="add"
	echo "注释内容:$commit"
	echo "当前分支是${branch}开始打包推送"
	gulp --build
	gulp lessAfter
	node_modules/.bin/webpack --config ./config/onDaily.js --progress --colors
	gulp assets
	echo "build √"
	git add -A
	echo "add √"
	git commit -m "$commit"
	echo "commit √"
	git push origin $branch
	echo "push √"
}

onlineDO(){
	branch=`git symbolic-ref --short -q HEAD`
	echo -n "输入注释(默认是add):"
	read commit
	[ ! "$commit" ] && commit="add"
	echo "注释内容:$commit"
	echo "当前分支是${branch}开始打包推送"
	gulp --build
	gulp lessAfter
	node_modules/.bin/webpack --config ./config/onLine.js --progress --colors
	gulp assets
	echo "build √"
	git add -A
	echo "add √"
	git commit -m "$commit"
	echo "commit √"
	git push origin $branch
	echo "push √"

}

createTagDO(){
	branch=`git symbolic-ref --short -q HEAD`
	branch=`echo $branch | cut -d '/' -f 2`
	echo "创建tag publish/$branch"
	git tag publish/$branch
	echo "tag publish/$branch √"
	git push origin publish/$branch
	echo "push √"
}

createBranchDO(){
	echo -n "请输入您想创建的分支版本(格式如:1.3.15)"
	read newbranch
	git checkout master
	git fetch --all
	git reset --hard origin/master
	git checkout -b daily/$newbranch
	# sed -i '5d' package.json
	# sed -i "5i \ \ \"version\": \"abc\"," config/onDaily.js
}


${type}DO

