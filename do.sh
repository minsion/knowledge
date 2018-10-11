#!/bin/bash
set -o errexit

echo -e "0.创建分支[createBranch]\n1.拉取代码[pull]\n2.上传代码[gitPush]\n3.创建页面[page]"
echo -n "输入你想要的操作:"
read type

if [[ $type -le 5 && $type -ge 0 ]]; then
	doArr=(createBranch  pull git page)
	type=${doArr[type]}
fi
createBranchDO(){
	echo -n "请输入您想创建的分支版本(格式如:1.3.15)"
	read newbranch
	git checkout master
	git fetch --all
	git reset --hard origin/master
	git checkout -b daily/$newbranch
}

gitDO(){
	branch=`git symbolic-ref --short -q HEAD`
	echo -n "输入注释(默认是add):"
	read commit
	[ ! "$commit" ] && commit="add"
	echo "注释内容:$commit"
	echo "当前分支是${branch}开始推送"
	git add -A
	echo -e "\033[32m add √ \033[0m"
	git commit -m "$commit"
	echo -e "\033[32m commit √ \033[0m"
	git push origin $branch
	echo -e "\033[32m push √ \033[0m"
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

${type}DO

