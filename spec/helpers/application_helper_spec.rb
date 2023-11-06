require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#bootstrap_class_for_flash' do
    it 'returns success for success flash type' do
      expect(helper.bootstrap_class_for_flash('success')).to eq('success')
    end

    it 'returns danger for error flash type' do
      expect(helper.bootstrap_class_for_flash('error')).to eq('danger')
    end

    it 'returns warning for alert flash type' do
      expect(helper.bootstrap_class_for_flash('alert')).to eq('warning')
    end

    it 'returns info for notice flash type' do
      expect(helper.bootstrap_class_for_flash('notice')).to eq('info')
    end

    it 'returns the stringified flash type for an unknown flash type' do
      expect(helper.bootstrap_class_for_flash('custom')).to eq('custom')
    end
  end
end
