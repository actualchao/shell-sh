#!bin/sh

# 这是一个自动发布脚本
# 通过在本地配置HOST 别名，ssh 连接服务器使用scp上传文件

publicPath='/disposal-app/'

read -p "Please enter your server alias Host name: " server

base_dir=$(cd "$(dirname "$0")";pwd)

ssh $server echo "login successed"

if [ "$?" == 255 ]
then
    read -p "Please enter your server user: " user
    read -p "Please enter your server ip: " ip

    dir=$base_dir/deploy.private
    
    if [ -f $dir ]
    then
      echo "\n\n"
      cat $dir
      echo "\n\n"
    else
      echo '\n\n不存在密钥文件\n\n'
      exit 1  
    fi    
    echo "\033[32m 插入 Host 别名到 ～/.ssh/config .... \033[0m\n"
    echo "\n\nHost $server\n\tHostName $ip\n\tUser $user\n\tIdentityFIle $dir\n\n\n"
    echo "\n\nHost $server\n\tHostName $ip\n\tUser $user\n\tIdentityFIle $dir\n" >> ~/.ssh/config

    ssh $server echo "login successed"
fi


npm run build


echo "\n正在删除。。。\n\t/opt/static$publicPath\n\n"

ssh $server "cd /opt/static/;rm -rf $publicPath;ls"

echo "\n正在上传。。。\n\t/opt/static$publicPath\n\n"

scp -r ./dist/ $server:/opt/static/

ssh $server "mv /opt/static/dist /opt/static/$publicPath;ls"




