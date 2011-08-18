require 'helper'

class TestTamponHelpers < Test::Unit::TestCase
  context "when intialized" do
    setup do 
     class HelperMethods
       include Capistrano::Helpers::TamponHelper
     end

     @test_class = HelperMethods.new

    end
    context "tags" do


      should "respond_to who" do
        assert_respond_to @test_class, :who
      end

      should "not be blank" do 
        puts "\ncurrent user: #{@test_class.who}"
        assert_equal false, @test_class.who.blank?
      end

      should 'tags should be an Array' do
        puts "\nall tags: #{@test_class.tags}"
        assert @test_class.tags.kind_of?(Array)
      end

    end

    context "then non-release tags" do

      should "respond_to non_release_tags" do
        assert_respond_to @test_class, :non_release_tags
      end

      should "return an Array" do
        assert @test_class.non_release_tags.kind_of?(Array)
      end

    end
    
    context "branches" do
      
      should "respond_to :branches" do
        assert_respond_to @test_class, :branches
      end

      should 'not be blank' do
        assert_equal false, @test_class.branches.empty?
      end

      should "respond to :current_branch" do 
        assert_respond_to @test_class, :current_branch
      end
      
      should "show the current branch" do
        puts "\ncurrent branch: #{@test_class.current_branch}"
        assert_equal "master", @test_class.current_branch
      end

    end
    
    context "version tags" do 
      
      should "respond_to version_tag_prefix" do
        assert_respond_to @test_class, :version_tag_prefix
      end

      should "be 'v'" do 
        assert_equal "v", @test_class.version_tag_prefix
      end

    end

    context "releases" do

      should "respond to releases" do
        assert_respond_to @test_class, :releases
      end

      should "only begin with the version tag prefix" do
        
      end
      
      should 'display all available releases' do 
        
      end

      should 'display latest release' do 
        assert_equal 'v1.4.2', @test_class.latest_release
      end

    end

  end
end
