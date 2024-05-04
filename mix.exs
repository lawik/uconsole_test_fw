defmodule CircuitsQuickstart.MixProject do
  use Mix.Project

  @app :circuits_quickstart
  @version "0.6.1"
  @all_targets [
    :uconsole
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.12",
      archives: [nerves_bootstrap: "~> 1.9"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  def application do
    [
      mod: {CircuitsQuickstart.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets, :ssl]
    ]
  end

  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10.1", runtime: false},
      {:shoehorn, "~> 0.9.0"},
      {:ring_logger, "~> 0.9"},
      {:toolshed, "~> 0.3"},

      # Circuits projects
      {:circuits_uart, "~> 1.3"},
      {:circuits_gpio, "~> 1.0"},
      {:circuits_i2c, "~> 1.0"},
      {:circuits_spi, "~> 1.2"},
      {:pinout, "~> 0.1"},
      {:power_control, github: "cjfreeze/power_control"},
      {:ramoops_logger, "~> 0.3", targets: @all_targets},
      {:input_event, "~> 1.4"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      {:nerves_system_uconsole, path: "../nerves_system_uconsole", runtime: false, targets: :uconsole, nerves: [compile: true]},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: [keep: ["Docs"]]
    ]
  end
end
