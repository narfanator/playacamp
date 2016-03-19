require 'test_helper'

class CampScoresControllerTest < ActionController::TestCase
  setup do
    @camp_score = camp_scores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:camp_scores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create camp_score" do
    assert_difference('CampScore.count') do
      post :create, camp_score: { build: @camp_score.build, contribution: @camp_score.contribution, participation: @camp_score.participation, preparation: @camp_score.preparation, teardown: @camp_score.teardown }
    end

    assert_redirected_to camp_score_path(assigns(:camp_score))
  end

  test "should show camp_score" do
    get :show, id: @camp_score
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @camp_score
    assert_response :success
  end

  test "should update camp_score" do
    patch :update, id: @camp_score, camp_score: { build: @camp_score.build, contribution: @camp_score.contribution, participation: @camp_score.participation, preparation: @camp_score.preparation, teardown: @camp_score.teardown }
    assert_redirected_to camp_score_path(assigns(:camp_score))
  end

  test "should destroy camp_score" do
    assert_difference('CampScore.count', -1) do
      delete :destroy, id: @camp_score
    end

    assert_redirected_to camp_scores_path
  end
end
