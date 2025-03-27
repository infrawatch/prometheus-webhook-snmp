#!/usr/bin/env python
# -*- coding: utf-8 -*-

import setuptools


with open('README.md') as readme_file:
    readme = readme_file.read()

with open('CHANGELOG.md') as changelog_file:
    changelog = changelog_file.read()


requirements = [
    'cherrypy==18.10.0',
    'click==8.1.8',
    'PyYAML==6.0.2',
    'mock==5.2.0',
    'prometheus_client==0.21.0',
    'pyfakefs==5.8.0',
    'pylint==3.3.6',
    'pysnmp==7.1.17',
    'pyasn1==0.6.0',
    'pytest==8.3.5',
    'pytest-runner==6.0.1',
    'python-dateutil==2.9.0.post0',
    'pip==25.0.1',
]

dependency_links = [
]

test_requirements = [
    # TODO: put package test requirements here
]

setuptools.setup(
    name='prometheus-webhook-snmp',
    version='1.5',
    description=("Prometheus Alertmanager receiver for SNMP traps"),
    long_description=readme + '\n---\n' + changelog,
    long_description_content_type='text/markdown',
    url='https://github.com/infrawatch/prometheus-webhook-snmp',
    py_modules=['prometheus_webhook_snmp.prometheus_webhook_snmp', 'prometheus_webhook_snmp.utils'],
    include_package_data=True,
    dependency_links=dependency_links,
    install_requires=requirements,
    license="GPLv3",
    data_files=[
        ('./share/doc/prometheus-webhook-snmp', ['CHANGELOG.md', 'README.md']),
    ],
    zip_safe=True,
    keywords='prometheus_webhook_snmp',
    test_suite='tests',
    tests_require=test_requirements,
    entry_points={
        'console_scripts': [
            'prometheus-webhook-snmp=prometheus_webhook_snmp.prometheus_webhook_snmp:cli',
        ],
    }
)
