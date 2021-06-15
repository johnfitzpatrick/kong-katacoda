
while kubectl cluster-info > /dev/null 2>&1 ; [ $? -ne 0 ];do
    sleep 2 ; echo Waiting for Kubernetes cluster
done
