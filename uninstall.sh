#!/bin/bash

azure servicefabric application delete fabric:/dreamhomesf
azure servicefabric application type unregister dreamhomesf 1.0.0
