# encoding: utf-8
require "paquet/gem"
require "stud/temporary"
require "fileutils"

describe Paquet::Gem do
  let(:target_path) { Stud::Temporary.pathname }
  let(:dummy_gem) { "dummy-gem" }

  subject { described_class.new(target_path) }

  it "adds gem to pack" do
    subject.add(dummy_gem)
    expect(subject.gems).to include(dummy_gem)
  end

  it "allows to ignore gems" do
    subject.ignore(dummy_gem)
    expect(subject.ignore?(dummy_gem))
  end

  it "keeps track of the number of gem to pack" do
    expect { subject.add(dummy_gem) }.to change { subject.size }.by(1)
  end

  context "when not configuring cache" do
    it "use_cache? returns false" do
      expect(subject.use_cache?).to be_truthy
    end
  end

  context "when configuring cache" do
    let(:cache_path) do
      p = Stud::Temporary.pathname
      FileUtils.mkdir_p(p)
      p
    end

    subject { described_class.new(target_path, cache_path) }

    it "use_cache? returns true" do
      expect(subject.use_cache?).to be_truthy
    end

    context "#find_in_cache" do
      let(:gem_full_name) { "super-lib-0.1.0.gem" }

      context "when the gem is in cache directory" do
        let(:gem_file_path) { File.join(cache_path, gem_full_name) }

        before do
          FileUtils.touch(gem_file_path)
        end

        it "returns true" do
          expect(subject.find_in_cache(gem_full_name)).to match(gem_file_path)
        end
      end

      context "when the gem is not in the cache directory" do
        it "returns false" do
          expect(subject.find_in_cache(gem_full_name)).to be_falsey
        end
      end
    end
  end
end
