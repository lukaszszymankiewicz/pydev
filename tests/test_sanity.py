"""Sanity check that the package and pytest wiring are set up correctly."""

from pv import __version__


def test_package_importable() -> None:
    assert __version__ == "0.1.0"
