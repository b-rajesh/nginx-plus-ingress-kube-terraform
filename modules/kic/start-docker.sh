open --hide --background -a Docker
until docker info
do
    sleep 5
done