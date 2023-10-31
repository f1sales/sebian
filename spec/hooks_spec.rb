require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  describe 'switch_source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = ''

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Fonte Teste'
      source
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'When there is no specific store' do
      it 'return only source name' do
        expect(switch_source).to eq('Fonte Teste')
      end
    end

    context 'Loja On-line' do
      before do
        lead.message = 'Três Riachos - Estrada Geral, S/N, Galpão - Loja On-line'
      end

      it 'should switch source by adding store group' do
        expect(switch_source).to eq('Fonte Teste - Loja On-line')
      end
    end

    context 'Bal. Camboriú' do
      before do
        lead.message = 'Centro -Terceira avenida, 39, Loja 04 - Bal. Camboriú'
      end

      it 'should switch source by adding store group' do
        expect(switch_source).to eq('Fonte Teste - Bal. Camboriú')
      end
    end

    context 'Blumenau II' do
      before do
        lead.message = 'Salto Norte -Rod. BR-470, 3000, Loja 169, Norte Shopping - Blumenau II'
      end

      it 'should switch source by adding store group' do
        expect(switch_source).to eq('Fonte Teste - Blumenau II')
      end
    end

    context 'Blumenau III' do
      before do
        lead.message = 'Centro - Rua XV de Novembro, 643 - Blumenau III'
      end

      it 'should switch source by adding store group' do
        expect(switch_source).to eq('Fonte Teste - Blumenau III')
      end
    end

    context 'São José III' do
      before do
        lead.message = 'Picadas do Sul - Rod. BR 101, KM 210, Continente Shopping - São José III'
      end

      it 'should switch source by adding store group' do
        expect(switch_source).to eq('Fonte Teste - São José III')
      end
    end
  end

  describe 'switch_salesman' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = ''

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Fonte Teste'
      source
    end

    let(:switch_salesman) { described_class.switch_salesman(lead) }

    context 'When there is no specific store' do
      it 'return only salesman name' do
        expect(switch_salesman).to eq({ email: '@sebian.com.br' })
      end
    end

    context 'Loja On-line' do
      before do
        lead.message = 'Três Riachos - Estrada Geral, S/N, Galpão - Loja On-line'
      end

      it 'should switch salesman to estradageralsngalpao@sebian.com.br' do
        expect(switch_salesman).to eq({ email: 'estradageralsngalpao@sebian.com.br' })
      end
    end

    context 'Bal. Camboriú' do
      before do
        lead.message = 'Centro - Terceira avenida, 39, Loja 04 - Bal. Camboriú'
      end

      it 'should switch salesman to estradageralsngalpao@sebian.com.br' do
        expect(switch_salesman).to eq({ email: 'terceiraavenida39loja04@sebian.com.br' })
      end
    end

    context 'Blumenau II' do
      before do
        lead.message = 'Salto Norte - Rod. BR-470, 3000, Loja 169, Norte Shopping - Blumenau II'
      end

      it 'should switch salesman to estradageralsngalpao@sebian.com.br' do
        expect(switch_salesman).to eq({ email: 'rodbr4703000loja169norteshopping@sebian.com.br' })
      end
    end

    context 'Blumenau III' do
      before do
        lead.message = 'Centro - Rua XV de Novembro, 643 - Blumenau III'
      end

      it 'should switch salesman to estradageralsngalpao@sebian.com.br' do
        expect(switch_salesman).to eq({ email: 'ruaxvdenovembro643@sebian.com.br' })
      end
    end

    context 'São José III' do
      before do
        lead.message = 'Picadas do Sul - Rod. BR 101, KM 210, Continente Shopping - São José III'
      end

      it 'should switch salesman to estradageralsngalpao@sebian.com.br' do
        expect(switch_salesman).to eq({ email: 'rodbr101km210continenteshopping@sebian.com.br' })
      end
    end
  end
end
