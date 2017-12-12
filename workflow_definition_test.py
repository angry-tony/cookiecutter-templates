#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import re
import yaml


def main():
    FILE_NAME = 'workflow_definition.yml'
    FILE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), FILE_NAME)

    with open(FILE_PATH, 'r') as f:
        lines = f.readlines()[1:]
        context = ''.join(lines)
        parsed_context = re.sub(r'\{\{.*\}\}', '', context)

    yaml_context = yaml.load(parsed_context)

    print 'Context was parsed successfully!'


if __name__ == "__main__":
    main()

