# TeslaMate

[![](https://readthedocs.org/projects/teslamate/badge/?version=latest)](https://teslamate.readthedocs.io/)
[![](https://travis-ci.org/adriankumpf/teslamate.svg?branch=master)](https://travis-ci.org/adriankumpf/teslamate)
[![](https://coveralls.io/repos/github/adriankumpf/teslamate/badge.svg?branch=master)](https://coveralls.io/github/adriankumpf/teslamate?branch=master)
[![](https://images.microbadger.com/badges/version/teslamate/teslamate.svg)](https://hub.docker.com/r/teslamate/teslamate)
[![](https://images.microbadger.com/badges/image/teslamate/teslamate.svg)](https://microbadger.com/images/teslamate/teslamate)
[![](https://img.shields.io/docker/pulls/teslamate/teslamate?color=%23099cec)](https://hub.docker.com/r/teslamate/teslamate)
[![](https://img.shields.io/badge/Donate-PayPal-ff69b4.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YE4CPXRAV9CVL&source=url)

A powerful, self-hosted data logger for your Tesla.

- Written in **[Elixir](https://elixir-lang.org/)**
- Data is stored in a **Postgres** database
- Visualization and data analysis with **Grafana**
- Vehicle data is published to a local **MQTT** Broker

## Features

**Dashboards**

- [Drive and charging reports](/docs/screenshots.md#charging-details)
- [Driving efficiency report](/docs/screenshots.md#efficiency)
- [Consumption (net / gross)](/docs/screenshots.md#efficiency)
- [Charge energy added vs energy used](/docs/screenshots.md#charges)
- [Vampire drain](/docs/screenshots.md#vampire-drain)
- [Projected 100% range (battery degradation)](/docs/screenshots.md#projected-range)
- [Charging Stats](/docs/screenshots.md#charging-stats)
- [Drive Stats](/docs/screenshots.md#drive-stats)
- [History of installed updates](/docs/screenshots.md#updates)
- [See when your car was online or asleep](/docs/screenshots.md#states)
- Lifetime driving map
- Visited addresses

**General**

- Little to no additional vampire drain: the car will fall asleep after a certain idle time
- Automatic address lookup
- Locally enriches positions with elevation data
- Easy integration into Home Assistant (via MQTT)
- Geo-fencing feature to create custom locations
- Supports multiple vehicles per Tesla Account
- Charge cost tracking

## Screenshots

![Drive Details](/docs/screenshots/drive.png)
![Web Interface](/docs/screenshots/web_interface.png)

<p align="center">
  <strong><a href="/docs/screenshots.md">MORE SCREENSHOTS</a></strong>
</p>

## Documentation

The full TeslaMate documentation is available on [Read the Docs](https://teslamate.readthedocs.io/).

- Getting Started
  - [Simple Docker install](https://teslamate.readthedocs.io/en/latest/installation/docker.html) (inside your home network)
  - [Advanced Docker install](https://teslamate.readthedocs.io/en/latest/installation/docker_advanced.html) (Traefik, Let's Encrypt, HTTPS, HTTP Basic Auth)
  - [Advanced Docker install](https://teslamate.readthedocs.io/en/latest/installation/docker_advanced_apache.html) (Apache2, HTTPS, HTTP Basic Auth)
  - [Manual install](https://teslamate.readthedocs.io/en/latest/installation/debian.html) (on Debian/Ubuntu without Docker)
  - [Kubernetes install](https://hub.helm.sh/charts/billimek/teslamate) (opinionated helm chart)
  - [Upgrading to a new version](https://teslamate.readthedocs.io/en/latest/upgrading.html)
  - [Frequently Asked Questions](https://teslamate.readthedocs.io/en/latest/faq.html)
- Sleep Mode
  - [Configuration](https://teslamate.readthedocs.io/en/latest/configuration/sleep.html)
  - [Shortcuts Setup (iOS)](https://teslamate.readthedocs.io/en/latest/configuration/guides/shortcuts.html)
  - [Tasker Setup (Android)](https://teslamate.readthedocs.io/en/latest/configuration/guides/tasker.html)
  - [MacroDroid Setup (Android)](https://teslamate.readthedocs.io/en/latest/configuration/guides/macro_droid.html)
- Integrations
  - [HomeAssistant](https://teslamate.readthedocs.io/en/latest/integrations/home_assistant.html)
  - [MQTT](https://teslamate.readthedocs.io/en/latest/integrations/mqtt.html)
- Advanced configuration
  - [Environment Variables](https://teslamate.readthedocs.io/en/latest/configuration/environment_variables.html)
- Maintenance
  - [Backup and Restore](https://teslamate.readthedocs.io/en/latest/maintenance/backup_restore.html)
  - [Manually fixing data](https://teslamate.readthedocs.io/en/latest/maintenance/manually_fixing_data.html)
  - [Updating Postgres](https://teslamate.readthedocs.io/en/latest/maintenance/updating_postgres.html)
- Development and Contributing
  - [Development](https://teslamate.readthedocs.io/en/latest/development.html)

## Donations

TeslaMate is open source and completely free for everyone to use.

Maintaining this project isn't effortless, or free. If you would like to
support further development, that would be awesome. If you don't, no problem;
just share your love and show your support.

<p align="center">
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YE4CPXRAV9CVL&source=url">
    <img src="docs/images/paypal-donate-button.png" alt="Donate with PayPal" />
  </a>
</p>

## Credits

- Authors: Adrian Kumpf – [List of contributors](https://github.com/adriankumpf/teslamate/graphs/contributors)
- Distributed under MIT License
