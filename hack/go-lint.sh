#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

command -v revive > /dev/null || go install github.com/mgechev/revive@latest

revive -config revive.toml ./... | grep -v zz_generated | tee -a revive_errors
if [ -s revive_errors ]  ; then
    code=1
fi
rm -f revive_errors
# The command in or will fetch the latest tag available for golangci-lint and install in $GOPATH/bin/
command -v golangci-lint > /dev/null || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
golangci-lint run ./... --enable revive --timeout 10m0s

# exit ${code:0}
