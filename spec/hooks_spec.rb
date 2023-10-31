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
end
