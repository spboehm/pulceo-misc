# Monitoring PULCEO with InfluxDB and Telegraf

## Install K3s

- Install K3s: `curl -sfL https://get.k3s.io | sh - `

## Install Helm

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Install Influxdata (skip, if pulceo has been bootstrapped)

```bash
helm repo add influxdata https://helm.influxdata.com/
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm upgrade --install my-release influxdata/influxdb2
```

Via graphical web interface (`ssh -L 5901:10.43.101.51:80 user@remote_host`):

- Create org `org`
- Create bucket `pulceo`
- Create API token via graphical web interface
- Create token: `export INFLUX_TOKEN=<INFLUX_TOKEN>`

## Install Telegraf

```bash
# influxdata-archive_compat.key GPG fingerprint:
#     9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install telegraf
```

- `sudo mkdir -p /var/run/secrets/kubernetes.io/serviceaccount`
- `sudo cp /var/lib/rancher/k3s/server/token /var/run/secrets/kubernetes.io/serviceaccount/token`
- `telegraf --config http://10.43.101.51:80/api/v2/telegrafs/<id>` OR
- `telegraf --config telegraf.conf`