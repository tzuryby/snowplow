#!/bin/bash

# Copyright (c) 2012 SnowPlow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Update these for your environment
RUNNER_PATH=/path/to/snowplow/3-etl/snowplow-emr-etl-runner
LOADER_PATH=/path/to/snowplow/4-storage/snowplow-storage-loader

RUNNER_CONFIG=/path/to/your-runner-config.yml
LOADER_CONFIG=/path/to/your-loader-config.yml

# Run the ETL job on EMR
BUNDLE_GEMFILE=${RUNNER_PATH}
bundle exec snowplow-emr-etl-runner --config ${RUNNER_CONFIG}

# Check the damage
ret_val=$?
if [ $ret_val -ne 0 ]; then
    echo "Error running EmrEtlRunner, exiting with return code ${ret_val}. StorageLoader not run"
    exit ret_val
fi

# If all okay, run the storage load too
BUNDLE_GEMFILE=${LOADER_PATH}
bundle exec snowplow-storage-loader --config ${LOADER_CONFIG}
