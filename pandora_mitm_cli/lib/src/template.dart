/// A plugin list template.
class Template {
  /// The name of the template, to be used with the CLI template option.
  final String name;

  /// A description of the template.
  final String description;

  /// The list of plugins in the template.
  ///
  /// The values are [PluginEntry.name]s.
  final List<String> plugins;

  const Template(this.name, this.description, this.plugins);
}
