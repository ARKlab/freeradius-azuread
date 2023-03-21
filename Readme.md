# FreeRadius with AzureAD authentication

Docker image, tailored to be launched in Azure Container Instances, to provide a Radius server that authenticates users with Azure AD without and Domain Services using [freeradius-oauth2-perl](https://github.com/jimdigriz/freeradius-oauth2-perl).

## BREAKING: Move from DockerHub to Github Packages

Due to [`Free Team`](https://www.docker.com/blog/we-apologize-we-did-a-terrible-job-announcing-the-end-of-docker-free-teams/) tier being sunset by DockerHub, ARK is going to deprecate Docker image repositoy.

Update your deployments from `arkenergy/freeradius-azuread:latest` to `ghcr.io/arklab/freeradius-azuread:latest`.


# How to

1. Setup an Azure AD Application as illustrated in the [freeradius-oauth2-perl](https://github.com/jimdigriz/freeradius-oauth2-perl) project.
2. Spin up `ghcr.io/arklab/freeradius-azuread:latest` image with the following Env

| Env | Description | Example |
|--|--|--|
| AzureAdDomain | Your user domain used in the FreeRadius realm. | example.com |
| AzureAdClientId | The client ID obtained in step1 | 62a1f590-f324-4921-8412-fd7bbd8baa5a |
| AzureAdSecret | The Application secret from step1 | ***** |
| NASName | The name of the NAS Client, used in FreeRadius client.conf | PFSense |
| NASNetwork | The authorized network source for the NAS client. | 172.28.0.4/32 |
| NASSecret | The secret used by the NAS client to connect. | **** |

This is the sample command to use.

```
docker run -p 1812:1812/udp -p 1813:1813/udp -e AzureAdDomain='example.com' -e AzureAdClientId='$client_id' -e AzureAdSecret='$secret' -e NASName=$clientNAme -e NASNetwork=172.28.0.4/32 -e NASSecret=$nasSecret ghcr.io/arklab/freeradius-azuread:latest
```

# Security caveat

For this to work the NAS should use PAP authentication, meaning the clear-text password is received by the RADIUS server.
Adding that to the fact that this image doesn't support RADSEC TLS between NAS client and RADIUS server, means that the clear-text password is transferred unencryped between the NAS client and the RADIUS server.

**Do not use this image if the channel between the NAS and this RADIUS server is unsecure.**
