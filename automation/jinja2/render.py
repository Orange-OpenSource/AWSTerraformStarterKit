#!/usr/bin/env python3

from __future__ import (absolute_import, division, print_function)

__metaclass__ = type

"""
    Software Name : AWSTerraformStarterKit
    SPDX-FileCopyrightText: Copyright (c) 2023 Orange Business
    SPDX-License-Identifier: BSD-3-Clause

    This software is distributed under the BSD License;
    see the LICENSE file for more details.

    Author: AWS Practice Team <awspractice.core@orange.com>
"""

import os
import sys

import jinja2
import yaml

import compute_deps


class Render:
    TEMPLATES_DIR = os.environ.get('TEMPLATES_DIR') if os.environ.get(
        'TEMPLATES_DIR') is not None else "/templates"

    def __init__(self, template_name=None, variables_path=None):
        self.template_name = template_name
        self.variables_path = variables_path
        self.env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(self.TEMPLATES_DIR),
            extensions=['jinja2.ext.loopcontrols'],
            autoescape=True,
            lstrip_blocks=True,
            newline_sequence="\n",
            trim_blocks=True,
            keep_trailing_newline=True
        )

    def yaml_filter(value):
        return yaml.dump(value, Dumper=yaml.RoundTripDumper, indent=4)

    def rend_template(self):
        env_data = {}
        for k, v in os.environ.items():
            env_data[k] = v
        var_data = {}
        with open(self.variables_path, closefd=True) as f:
            var_data = yaml.full_load(f)
        # compute execution plan
        for idx in range(len(var_data['plans'])):
            var_data['plans'][idx] = var_data['plans'][idx] if var_data['plans'][idx].startswith('name: ') else {
                'name': var_data['plans'][idx]} # this is for backward compatiblity
        exec_plan = compute_deps.build_exec_plan(plans=var_data['plans'])
        var_data['exec_plan'] = exec_plan
        ## reorganize plans order based on execution order
        var_data['plans'] = []
        for exec_batch in exec_plan:
            for plan in exec_batch:
                var_data['plans'].append(plan)
        # build final variables
        data = env_data
        for k, v in var_data.items():
            data[k] = v
        self.env.filters['yaml'] = self.yaml_filter
        self.env.globals["environ"] = lambda key: os.environ.get(key)

        try:
            rendered = self.env.get_template(self.template_name).render(data)
        except Exception as e:
            raise e

        return rendered


def main():
    min_args = 3
    if len(sys.argv) < min_args:
        raise Exception(
            "Error: Expecting at least {} args. Got {}, args={}".format(min_args, len(sys.argv), sys.argv))
    sys.stdout.write(Render(sys.argv[1], sys.argv[2]).rend_template())


if __name__ == '__main__':
    main()
