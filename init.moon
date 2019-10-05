sort_handler = (opts = {}) -> howl.app.editor.buffer\as_one_undo ->
  {:pattern, :reverse} = opts

  filter = if pattern
    (line) -> line.text\ufind pattern
  else -> true

  local compare
  if reverse
    compare = (a,b) -> a > b

  lines = howl.app.editor.active_lines
  if #lines <= 1
    lines = howl.app.editor.buffer.lines

  lines = [line for line in *lines when (line.size > 0) and filter(line)]
  strlines = [tostring(l) for l in *lines]

  table.sort strlines, compare
  lines[i].text = strlines[i] for i=1, #lines

input = howl.interact.read_text -- Make this more interactive.
get_text = (result) -> result

commands = {
  {
    name: 'sort'
    description: 'Sort lines matching a pattern (global or selection)'
    :input
    handler: (pattern) -> sort_handler :pattern
    :get_text
  }
  {
    name: 'sort!'
    description: 'Sort lines  matching a pattern in reverse order (global or selection)'
    :input
    handler: (pattern) -> sort_handler :pattern, reverse: true
    :get_text
  }
  {
    name: 'sort-regex'
    description: 'Sort lines matching a regex (global or selection)'
    :input
    handler: (regex) -> sort_handler pattern: r(regex)
    :get_text
  }
  {
    name: 'sort!-regex'
    description: 'Sort lines  matching a regex in reverse order (global or selection)'
    :input
    handler: (regex) -> sort_handler pattern: r(regex), reverse: true
    :get_text
  }
}

howl.command.register cmd for cmd in *commands

unload = -> howl.command.unregister name for {:name} in *commands

{
  info:
    author: 'Copyright (c) 2019 Jan Felix Langenbach'
    description: 'Vim-like sort commands'
    license: 'MIT'
  :unload
}
