
While an operator and CRD can be generated from scratch, there is a tool called `kubebuilder` that can generate scaffolding to get you started quickly.

Get started by initializing a Kubebuilder application with the `kubebuilder init` command like this:

> **Note:** The environment ships with Go 1.21, while the default `go.kubebuilder.io/v4` plugin expects Go 1.23 or newer. We can bypass the guard by adding `--skip-go-version-check`.

```bash
kubebuilder init \
  --plugins=go.kubebuilder.io/v4 \
  --domain example.com \
  --repo example.com/operator-demo \
  --skip-go-version-check
```{{exec}}

> NOTE: Kubebuilder is already installed on this machine

This command has generated scaffolding files now visible in the `Editor` tab. Click on the `Editor` tab at the top of your screen to view a visual studio code type Integrated Development Environment(IDE). From the directory navigation on the left-hand side, select the `src` directory. 

Within the `src` directory, you'll see a `Makefile`. Kubebuilder uses a [Makefile](https://www.gnu.org/software/make/manual/html_node/Introduction.html) as home for all useful commands (called "targets").

To see available targets, click on the `Makefile` and it will open in the right-hand pane. The available targets are displayed after the word `.PHONY:`

For example, the `.PHONY: run` target will run a controller from your host (locally). Let's try doing that!

Click on `Tab 1` to go back to the command prompt and type the command:

```bash
go env -w GOPROXY=https://proxy.golang.org,direct
go env -w GOSUMDB=sum.golang.org
go mod tidy

cd ~/src && make run
```{{exec}}

> NOTE: This command may take a few minutes (particularly `go vet` may appear to hang!).

While this command is running, navigate to the `main.go` file back in the `Editor` tab. The file is right next to the `Makefile` we were looking at before. 

In this file, look at line 64 to see the `NewManager` function, which is what creates the operator application. In the list of options passed to this `NewManager` function (lines 65 to 70), you will see configuration for both a metrics and health probe endpoint. These will become visible in the output of the `make run` command.

Return to the `Tab 1` tab and view the progress of the run command.

You should see a few commands running. This includes prerequisite Make targets like `fmt` and `vet`. When it is complete, you should see the following four log lines at the end of the output:

```bash
INFO  controller-runtime.metrics  Metrics server is starting to listen  {"addr": ":8080"}
INFO  setup starting manager
INFO  Starting server {"path": "/metrics", "kind": "metrics", "addr": "[::]:8080"}
INFO  Starting server {"kind": "health probe", "addr": "[::]:8081"}
```

Once you see this output, press `ctrl + c` to stop running the controller and move on to the next step.
