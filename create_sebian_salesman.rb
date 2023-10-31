# frozen_string_literal: true

def gen_password
  password = 3.times.map { rand(1..9) }.join('')
  password += %i[@ $ ! & #].sample.to_s
  password += 3.times.map { rand(1..9) }.join('')

  password
end

def emailize(string)
  string.dup.force_encoding('UTF-8').unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(/\W+/, '')
end

SEBIAN_EMAIL_DOMAIN = '@sebian.com.br'

Admin.skip_callback(:create, :after, :subscribe_mail_list)
Salesman.skip_callback(:create, :after, :send_sign_up_instructions)

adm_names = [
  'Biguaçu',
  'Palhoça',
  'São José',
  'Florianópolis',
  'Biguaçu II',
  'São José II',
  'Bal. Camboriú',
  'Tijucas  ',
  'Itapema',
  'Itajaí',
  'Bal. Camboriú II',
  'Itajaí II  ',
  'Brusque',
  'Florianópolis II',
  'Itajaí III',
  'Palhoça II',
  'Navegantes',
  'Florianópolis III',
  'Palhoça III',
  'Itapema 2',
  'Criciúma',
  'São José III',
  'Blumenau',
  'Imbituba',
  'Tubarão',
  'Blumenau II',
  'São João Batista',
  'Criciúma II',
  'Blumenau III (Inaugura dia 14/11)',
  'Loja On-line'
].map {|adm| adm.unicode_normalize(:nfkd).encode('ASCII', replace: '')}

stores = [
  'Três Riachos - Estrada Geral, S/N, Galpão - Loja On-line',
  'Centro - Terceira avenida, 39, Loja 04 - Bal. Camboriú',
  'Centro - Av. do Estado, 3240 - Bal. Camboriú II',
  'Fortaleza - Rua Francisco Vahldieck, 1020 - Blumenau',
  'Salto Norte - Rod. BR-470, 3000, Loja 169, Norte Shopping - Blumenau II',
  'Centro - Rua XV de Novembro, 643 - Blumenau III',
  'Centro - Rua Conselheiro Rui Barbosa, 43, Sala 01 - Brusque',
  'Fazenda - Avenida Osvaldo Reis, 839, Sala 210 - Itajaí II',
  'São Vicente - Rua Estefano José Vanolli, 984 - Itajaí III',
  'Meia Praia - Segunda Avenida, 861 - Itapema',
  'Centro - Avenida João Sacavem, 222 - Navegantes',
  'Centro - Rua Ex Combatente Narcizo Cim, 85 - São João Batista',
  'Centro - Av. Jacobe Lameu Tavares, 35 -  Tijucas',
  'Centro - Rua Prefeito Leopoldo Freiberger, 578, Sala 01 - Biguaçu ',
  'Centro - Rua Getúlio Vargas, 123 - Biguaçu II',
  'Próspera - Av. Jorge Elias De Lucca , 677, Piso L1, Nações Shopping - Criciúma',
  'Centro - Av. Rui Barbosa, 36 - Criciúma II',
  'Centro - Rua Altamiro Guimarães, 265 - Florianópolis',
  'Centro - Rua Esteves Junior, 294 - Florianópolis II',
  'Ingleses - Rodovia Armando Kalil Bulos, 6088 - Florianópolis III',
  'Centro - Rua Nereu Ramos, 728 - Imbituba',
  'Centro - Rua José Maria da Luz, 2891 - Palhoça',
  'Bela vista - Rua José Onófre Pereira, 665 - Palhoça II',
  'Jd. Eldorado - Av. Gentil Reinaldo Cordioli, 103, Loja 03 - Palhoça III',
  'Campinas - Av. Presidente Kennedy, 143 - São José',
  'Barreiros - Rua Hidalgo Araújo, 82 - São José II',
  'Picadas do Sul - Rod. BR 101, KM 210, Continente Shopping - São José III',
  'Centro - Av. Marcolino Martins Cabral, 798 - Tubarão'
].map {|store| store.unicode_normalize(:nfkd).encode('ASCII', replace: '')}

resp_s = []
resp_a = []
stores.each_with_index do |store, i|
  # 1. admmin
  # 2. gen teams
  # 3. gen salesman
  salesman_name, team_name = store.split(' - ')[1..].map(&:strip)
  salesman_email = emailize(salesman_name)
  salesman_email += SEBIAN_EMAIL_DOMAIN
  admin_name = adm_names[i]
  admin_email = "#{emailize(team_name)}#{SEBIAN_EMAIL_DOMAIN}"
  team = Team.find_or_create_by!(name: team_name)
  adm = Admin.where(email: admin_email).first
  puts team
  puts '-------'
  puts "Team: #{team.name} - ID: #{team.id}"
  puts '-------'

  if adm.nil?
    admin_attr = { email: admin_email, password: (gen_password + gen_password), name: admin_name,
                   confirmed_at: Time.now, team: team }
    Admin.create!(admin_attr)
    puts "\n\nAdmin"
    puts admin_attr
    resp_a << admin_attr
    puts '-------'
    n = resp_a.size - 1
    puts "Email: #{resp_a[n][:email]} -> Password: #{resp_a[n][:password]}"
    puts "Pattern: #{resp_a[n][:email]},#{resp_a[n][:password]}"
    puts '-------'
  else
    puts "\n\nAdmin: #{adm.email} already exists."
    puts "Name: #{adm.name}, ID: #{adm.id}"
  end

  salesman_attr = { name: salesman_name, email: salesman_email, teams: [team], phone: rand(99_999_999_999),
                    password: gen_password }
  Salesman.create!(salesman_attr)
  puts "\n\nSalesman"
  puts salesman_attr
  resp_s << salesman_attr
  puts '-------'
  puts "Email: #{resp_s[i][:email]} -> Password: #{resp_s[i][:password]}"
  puts "Pattern: #{resp_s[i][:email]},#{resp_s[i][:password]}"
  puts '-------'
  puts "\n"
  puts '=======' * 10
  puts '=======' * 10
  puts "\n\n\n"
end;''


# Admin that already exists, but is not in the spreadsheet
# password  = (gen_password + gen_password)
# Admin.where(email: email).first.update(password: password)
