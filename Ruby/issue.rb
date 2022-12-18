# frozen_string_literal: false

require 'readline'
require 'digest/md5'

# RTM Code Issue
class Issue
  FROB_URL = 'https://www.rememberthemilk.com/services/auth/'.freeze
  AUTH_TOKEN_URL = 'https://api.rememberthemilk.com/services/rest/'.freeze

  def initialize
    buffer = ask(['Enter the number', '1. frob', '2. Auth Token'])

    case buffer
    when '1', 'frob'
      frob
    when '2', 'auth', 'auth_token', 'AuthToken'
      auth_token
    else
      puts 'Enter 1 or 2.'
    end
  end

  # Auth Token発行時に利用するfrobの発行URLの作成
  #
  # 1. secret_keyを入力(API利用申請時にkeyと一緒にもらったもの)
  # 2. api_keyを入力(API利用申請時にkeyと一緒にもらったもの)
  # 3. md5でハッシュ化
  # @see https://www.rememberthemilk.com/services/api/authentication.rtm
  def frob
    secret_key = ask('Enter the 「secret key」')
    api_key = ask('Enter the 「api key」')

    code = secret_key
    code << 'api_key' << api_key
    code << 'perms' << 'read'
    frob = Digest::MD5.hexdigest(code)

    puts "#{FROB_URL}?api_key=#{api_key}&perms=read&api_sig=#{frob}"
  end

  # Auth Tokenの発行
  #
  # 1. secret_keyを入力(API利用申請時にkeyと一緒にもらったもの)
  # 2. api_keyを入力(API利用申請時にkeyと一緒にもらったもの)
  # 3. frobを入力
  # 4. md5でハッシュ化
  # @see https://www.rememberthemilk.com/services/api/methods.rtm
  def auth_token
    secret_key = ask('Enter the 「secret key」')
    api_key = ask('Enter the 「api key」')
    frob = ask('Enter the 「frob」')

    code = secret_key
    code << 'api_key' << api_key
    code << 'format' << 'json'
    code << 'frob' << frob
    code << 'method' << 'rtm.auth.getToken'
    api_sig = Digest::MD5.hexdigest(code)

    puts "#{AUTH_TOKEN_URL}?api_key=#{api_key}&format=json&frob=#{frob}&method=rtm.auth.getToken&api_sig=#{api_sig}"
  end

  private

  def ask(question = nil)
    return Readline.readline('> ') if question.nil?

    question.map { |q| puts q } if question.instance_of?(Array)
    puts question if question.instance_of?(String)

    Readline.readline('> ')
  end
end

Issue.new
