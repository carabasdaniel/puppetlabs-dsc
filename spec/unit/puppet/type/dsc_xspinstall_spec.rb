#!/usr/bin/env ruby
require 'spec_helper'

describe Puppet::Type.type(:dsc_xspinstall) do

  let :dsc_xspinstall do
    Puppet::Type.type(:dsc_xspinstall).new(
      :name     => 'foo',
      :dsc_binarydir => 'foo',
    )
  end

  it "should stringify normally" do
    expect(dsc_xspinstall.to_s).to eq("Dsc_xspinstall[foo]")
  end

  it 'should require that dsc_binarydir is specified' do
    #dsc_xspinstall[:dsc_binarydir]
    expect { Puppet::Type.type(:dsc_xspinstall).new(
      :name     => 'foo',
      :dsc_productkey => 'foo',
    )}.to raise_error(Puppet::Error, /dsc_binarydir is a required attribute/)
  end

  it 'should not accept array for dsc_binarydir' do
    expect{dsc_xspinstall[:dsc_binarydir] = ["foo", "bar", "spec"]}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept boolean for dsc_binarydir' do
    expect{dsc_xspinstall[:dsc_binarydir] = true}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept int for dsc_binarydir' do
    expect{dsc_xspinstall[:dsc_binarydir] = -16}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept uint for dsc_binarydir' do
    expect{dsc_xspinstall[:dsc_binarydir] = 16}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept array for dsc_productkey' do
    expect{dsc_xspinstall[:dsc_productkey] = ["foo", "bar", "spec"]}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept boolean for dsc_productkey' do
    expect{dsc_xspinstall[:dsc_productkey] = true}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept int for dsc_productkey' do
    expect{dsc_xspinstall[:dsc_productkey] = -16}.to raise_error(Puppet::ResourceError)
  end

  it 'should not accept uint for dsc_productkey' do
    expect{dsc_xspinstall[:dsc_productkey] = 16}.to raise_error(Puppet::ResourceError)
  end

  # Configuration PROVIDER TESTS

  describe "powershell provider tests" do

    it "should successfully instanciate the provider" do
      described_class.provider(:powershell).new(dsc_xspinstall)
    end

    before(:each) do
      @provider = described_class.provider(:powershell).new(dsc_xspinstall)
    end

    describe "when dscmeta_import_resource is true (default) and dscmeta_module_name existing/is defined " do

      it "should compute powershell dsc test script with Invoke-DscResource" do
        expect(@provider.ps_script_content('test')).to match(/Invoke-DscResource/)
      end

      it "should compute powershell dsc test script with method Test" do
        expect(@provider.ps_script_content('test')).to match(/Method\s+=\s*'test'/)
      end

      it "should compute powershell dsc set script with Invoke-DscResource" do
        expect(@provider.ps_script_content('set')).to match(/Invoke-DscResource/)
      end

      it "should compute powershell dsc test script with method Set" do
        expect(@provider.ps_script_content('set')).to match(/Method\s+=\s*'set'/)
      end

    end

  end
end