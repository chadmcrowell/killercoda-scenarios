
With the token copied to your clipboard, paste it into an environment variable named TOKEN and base64 decode it with the command `TOKEN='6IlJ6czFud2llb3pKN05hUDh2Q3VNeDRXNWJ3eUhFczh0TW' | base64 -d`. 

> The token value has been shortened for demonstration purposes

Next, you can get the output of `kubectl config view` and copy the server address (mine is `https://kind-control-plane:6443`). Save that in an environment variable named “SERVER” with the command `SERVER=https://kind-control-plane:6443`