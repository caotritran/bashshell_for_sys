/bin/bash
#script check docker stop and start docker


container_name="hello"
images_name="hello"

echo "$(docker ps -aq -f name=$container_name)"

if [ ! -z "$(docker ps -aq -f name=$container_name)" ]; then
        echo "$(docker ps -aq -f name=${container_name})"

        if [ "$(docker ps -aq -f name=$container_name -f status=exited)" ]; then
                docker rm $container_name
        fi

        docker run -d --name $container_name $images_name

fi
