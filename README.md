# ⚙️ Nix Config Generator

A small utility library for generating configuration text using Nix.

This project focuses on converting structured Nix data into configuration formats used by various programs and services.

It follows a similar idea to Home Manager — describing configurations declaratively in Nix — but instead of applying them directly, it returns the generated configuration as plain strings.

This allows the result to be written to files, embedded into other configurations, or processed further as needed.
