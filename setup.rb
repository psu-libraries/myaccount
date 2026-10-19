# frozen_string_literal: true

# ! ################################################### Helpers #################################################### ! #

class Colors
  class << self
    # Failure
    def red; "\e[31m" end

    # Success
    def green; "\e[32m" end

    # Warning / Manual Intervention
    def yellow; "\e[33m" end

    # Indicate next step starting
    def blue; "\e[34m" end

    # Emphasis
    def magenta; "\e[35m" end

    # Links
    def cyan; "\e[36m" end

    def default; "\e[39m" end
  end
end

def colorize(color, string)
  "#{color}#{string}#{Colors.default}"
end

def execute_commands(commands, allow_failure: false)
  unless commands.is_a?(Array)
    abort("#{Colors.red}#{commands} is not an array. Setup aborted!")
  end

  commands.each do |cmd|
    if allow_failure
      system(cmd)
    elsif !system(cmd)
      abort("#{Colors.red}#{cmd} failed. Setup aborted!")
    end
  end
end

def get_user_input(text, accepted_chars)
  unless accepted_chars.is_a?(Set)
    abort("#{Colors.red} accepted_chars must be a Set. Setup aborted!")
  end

  user_input = ''

  while !accepted_chars.include?(user_input)
    print text
    user_input = gets.chomp
    user_input.downcase!
  end

  user_input
end

# ! ################################################## Logic Code ################################################## ! #

def ruby_install
  puts colorize(Colors.blue, "\nChecking Ruby installation...")

  ruby_version = File.read('.ruby-version').strip
  rbenv_version = `rbenv version`.split[0]

  if ruby_version == rbenv_version
    puts colorize(Colors.blue, '.ruby_version matches rbenv version. Skipping...')
  else
    puts colorize(Colors.blue, 'Installing Ruby')

    execute_commands(
      [
        'rbenv install'
      ]
    )
  end
end

def bundle_install
  puts colorize(Colors.blue, "\nInstalling gems...")

  execute_commands(
    [
      'bundle config set without production',
      'bundle install'
    ]
  )
end

def setup_envrc(vault_path = 'secret/app/myaccount/dev', environment_file = '.envrc')
  puts colorize(Colors.blue, "\nSetting up #{environment_file} file...")

  if File.exist?(environment_file)
    puts colorize(Colors.blue, "#{environment_file} file found. Skipping creation step...")
  else
    puts colorize(Colors.yellow, "#{environment_file} file not found! Copying from .envrc.example...")

    execute_commands(
      [
        "cp .envrc.example #{environment_file}"
      ]
    )
  end

  if system("vault kv get #{vault_path}", out: File::NULL)
    envrc = Hash.new
    line_number = 1

    File.readlines(environment_file, chomp: true).each do |line|
      unless line.start_with?('#') || line.strip == ''
        key = line.split('=')[0].split[1]
        value = `vault kv get -field="#{key}" #{vault_path}`
        envrc[key] = { value: value, line: line_number }
      end

      line_number += 1
    end

    File.open(environment_file, 'r+') do |file|
      lines = file.each_line.to_a
      always_overwrite_line = false
      always_ignore_overwrite = false

      envrc.each do |key, value|
        secret = value[:value]
        line_num = value[:line] - 1
        curr_line = lines[line_num].split('=')[1].strip
        overwrite_line = false

        # Checks if the line already has a value, and asks the user if it should be overridden.
        if curr_line.match?(/^['"\s]*$/)
          overwrite_line = true
        else
          unless always_overwrite_line || always_ignore_overwrite
            user_input = get_user_input(
              colorize(Colors.yellow, "#{key} already has a set value." \
                                      "\n\n\tSubmit 'y' to overwrite this value." \
                                      "\n\tSubmit 'n' to ignore this value." \
                                      "\n\tSubmit 'a' to overwrite the current value and all future conflicts." \
                                      "\n\tSubmit 'x' to ignore this value and all future conflicts." \
                                      "\n\nSubmit your response here: "),
              Set['y', 'a', 'n', 'x']
            )

            case user_input
            when 'y'
              overwrite_line = true
            when 'a'
              always_overwrite_line = true
            when 'x'
              always_ignore_overwrite = true
            end
          end
        end

        if (overwrite_line || always_overwrite_line) && !always_ignore_overwrite
          lines[line_num] = "export #{key}='#{secret}'\n"
          file.rewind
          file.write(lines.join)
        end
      end
    end
  else
    puts colorize(Colors.yellow, "Warning! Vault command not found OR not authenticated. The setup program is now paused so you can do one of the following:\n")
    puts colorize(Colors.yellow, "\t- Abort this program, install Vault CLI or ensure authentication, and rerun this program when it is configured.\n" \
                                 "\t- Manually populate .envrc file.\n")

    user_input = get_user_input(
      colorize(Colors.yellow, "Submit 'a' to abort this program, or submit 'c' to continue (after populating .envrc): "),
      Set['a', 'c']
    )

    if user_input == 'a'
      exit
    end
  end

  execute_commands(
    [
      'direnv allow .envrc'
    ]
  )
end

def yarn
  puts colorize(Colors.blue, "\nInstalling JS dependencies...")

  execute_commands(
    [
      'yarn'
    ]
  )
end

def modify_header_value
  puts colorize(Colors.blue, "\nDisplaying Modify Header Value instructions...")
  puts colorize(Colors.yellow, 'This is a manual step. Please follow the instructions below:')

  puts "#{colorize(Colors.yellow, "\nMake sure you have the")} #{colorize(Colors.magenta, 'Modify Header Values')} " \
       "#{colorize(Colors.yellow, 'extension installed on Google Chrome and/or Firefox.')}"
  puts 'Google Chrome: ' \
       "#{colorize(Colors.cyan, 'https://chromewebstore.google.com/detail/modify-header-value-http/cbdibdfhahmknbkkojljfncpnhmacdek?pli=1')}" \
       "\nFirefox: " \
       "#{colorize(Colors.cyan, 'https://addons.mozilla.org/en-US/firefox/addon/modify-header-value/')}" \
       "\n\n"

  puts colorize(Colors.yellow, 'Add the following values to the Modify Header Values extension ' \
                               '(populate [access_id] with your PSU access ID (ex: abc1234)):')
  puts "\tURL: #{colorize(Colors.magenta, 'http://localhost:3000')}" \
       "\n\tHEADER NAME: #{colorize(Colors.magenta, 'X_AUTH_REQUEST_EMAIL')}" \
       "\n\tHEADER VALUE: #{colorize(Colors.magenta, '[access_id]@psu.edu')}"
  puts "\n"
  puts "\tURL: #{colorize(Colors.magenta, 'http://localhost:3000')}" \
       "\n\tHEADER NAME: #{colorize(Colors.magenta, 'REMOTE_USER')}" \
       "\n\tHEADER VALUE: #{colorize(Colors.magenta, '[access_id]')}"

  get_user_input(
    colorize(Colors.yellow, "Submit 'y' to continue: "),
    Set['y']
  )
end

def build_containers
  puts colorize(Colors.blue, "\nBuilding Docker containers...")

  execute_commands(
    [
      'docker compose build'
    ]
  )
end

def finish
  puts "#{colorize(Colors.green, "\nSet up complete!")} To start developing, " \
       "execute the following command(s): \n\n"
  puts "\tdocker compose up \n\n" \
end

def main
  puts colorize(Colors.blue, 'Setting up myaccount...')
  ruby_install
  bundle_install
  setup_envrc
  yarn
  modify_header_value
  build_containers
  finish
end

main
