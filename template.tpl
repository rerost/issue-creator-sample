on:
  schedule:
    - cron: "{{ .Schedule }}"

jobs:
  {{ .Name }}:
    name: Issue Create
    runs-on: ubuntu-latest
    steps:

    - name: Set up Go 1.13
      uses: actions/setup-go@v1
      with:
        go-version: 1.13
      id: go

    - name: Check out code into the Go module directory
      uses: actions/checkout@v1

    - name: Setup Issue Creator
      run: |
        mkdir .tmp_issue_creator
        cd .tmp_issue_creator
        export GO111MODULE=on
        go get github.com/rerost/issue-creator

    - name: Issue Create
      run: |
        export PATH=$PATH:$(go env GOPATH)/bin
        export GO111MODULE=on
        export GITHUBACCESSTOKEN={{`${{ secrets.GITHUB_TOKEN }}`}}
        {{ range $index, $var := .Commands}} {{$var}} {{- end }}
