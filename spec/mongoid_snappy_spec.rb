# coding: utf-8

require 'spec_helper'

describe MongoidSnappy do
  it 'correctly stores data' do
    100.times do
      text = Faker::Lorem.paragraphs(5).join(" ")
      c = Dummy.new(long_text: text)
      c.long_text.should eq text
      c.save.should be_true
      c.long_text.should eq text
      c.read_attribute(:long_text).data.length.should be < text.length
      Dummy.find(c.id).long_text.should eq text
    end
  end

  it 'correctly migrates data from string field' do
    text = Faker::Lorem.paragraphs(3).join(" ")
    c = Dummy.new(migrate_test: text)
    c.save.should be_true
    Migrated.first.migrate_test.should eq text
  end

  it 'correctly looks up string in DB' do
    text = Faker::Lorem.words(5).join(" ")
    c = Dummy.new(long_text: text)
    c.long_text.should eq text
    c.save.should be_true
    c.long_text.should eq text

    f = Dummy.where(long_text: text).first
    f.should_not be_nil
    f.long_text.should eq text
  end

  it 'correctly looks up string in DB' do
    text = Mongoid::Snappy.new(Faker::Lorem.words(5).join(" "))
    c = Dummy.new(long_text: text)
    c.long_text.should eq text
    c.save.should be_true
    c.long_text.should eq text

    f = Dummy.where(long_text: text).first
    f.should_not be_nil
    f.long_text.should eq text
  end
end