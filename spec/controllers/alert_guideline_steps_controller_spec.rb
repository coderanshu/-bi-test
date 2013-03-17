require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AlertGuidelineStepsController do

  # This should return the minimal set of attributes required to create a valid
  # AlertGuidelineStep. As you add validations to AlertGuidelineStep, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "alert_id" => "1" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AlertGuidelineStepsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all alert_guideline_steps as @alert_guideline_steps" do
      alert_guideline_step = AlertGuidelineStep.create! valid_attributes
      get :index, {}, valid_session
      assigns(:alert_guideline_steps).should eq([alert_guideline_step])
    end
  end

  describe "GET show" do
    it "assigns the requested alert_guideline_step as @alert_guideline_step" do
      alert_guideline_step = AlertGuidelineStep.create! valid_attributes
      get :show, {:id => alert_guideline_step.to_param}, valid_session
      assigns(:alert_guideline_step).should eq(alert_guideline_step)
    end
  end

  describe "GET new" do
    it "assigns a new alert_guideline_step as @alert_guideline_step" do
      get :new, {}, valid_session
      assigns(:alert_guideline_step).should be_a_new(AlertGuidelineStep)
    end
  end

  describe "GET edit" do
    it "assigns the requested alert_guideline_step as @alert_guideline_step" do
      alert_guideline_step = AlertGuidelineStep.create! valid_attributes
      get :edit, {:id => alert_guideline_step.to_param}, valid_session
      assigns(:alert_guideline_step).should eq(alert_guideline_step)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AlertGuidelineStep" do
        expect {
          post :create, {:alert_guideline_step => valid_attributes}, valid_session
        }.to change(AlertGuidelineStep, :count).by(1)
      end

      it "assigns a newly created alert_guideline_step as @alert_guideline_step" do
        post :create, {:alert_guideline_step => valid_attributes}, valid_session
        assigns(:alert_guideline_step).should be_a(AlertGuidelineStep)
        assigns(:alert_guideline_step).should be_persisted
      end

      it "redirects to the created alert_guideline_step" do
        post :create, {:alert_guideline_step => valid_attributes}, valid_session
        response.should redirect_to(AlertGuidelineStep.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved alert_guideline_step as @alert_guideline_step" do
        # Trigger the behavior that occurs when invalid params are submitted
        AlertGuidelineStep.any_instance.stub(:save).and_return(false)
        post :create, {:alert_guideline_step => { "alert_id" => "invalid value" }}, valid_session
        assigns(:alert_guideline_step).should be_a_new(AlertGuidelineStep)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AlertGuidelineStep.any_instance.stub(:save).and_return(false)
        post :create, {:alert_guideline_step => { "alert_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested alert_guideline_step" do
        alert_guideline_step = AlertGuidelineStep.create! valid_attributes
        # Assuming there are no other alert_guideline_steps in the database, this
        # specifies that the AlertGuidelineStep created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AlertGuidelineStep.any_instance.should_receive(:update_attributes).with({ "alert_id" => "1" })
        put :update, {:id => alert_guideline_step.to_param, :alert_guideline_step => { "alert_id" => "1" }}, valid_session
      end

      it "assigns the requested alert_guideline_step as @alert_guideline_step" do
        alert_guideline_step = AlertGuidelineStep.create! valid_attributes
        put :update, {:id => alert_guideline_step.to_param, :alert_guideline_step => valid_attributes}, valid_session
        assigns(:alert_guideline_step).should eq(alert_guideline_step)
      end

      it "redirects to the alert_guideline_step" do
        alert_guideline_step = AlertGuidelineStep.create! valid_attributes
        put :update, {:id => alert_guideline_step.to_param, :alert_guideline_step => valid_attributes}, valid_session
        response.should redirect_to(alert_guideline_step)
      end
    end

    describe "with invalid params" do
      it "assigns the alert_guideline_step as @alert_guideline_step" do
        alert_guideline_step = AlertGuidelineStep.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AlertGuidelineStep.any_instance.stub(:save).and_return(false)
        put :update, {:id => alert_guideline_step.to_param, :alert_guideline_step => { "alert_id" => "invalid value" }}, valid_session
        assigns(:alert_guideline_step).should eq(alert_guideline_step)
      end

      it "re-renders the 'edit' template" do
        alert_guideline_step = AlertGuidelineStep.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AlertGuidelineStep.any_instance.stub(:save).and_return(false)
        put :update, {:id => alert_guideline_step.to_param, :alert_guideline_step => { "alert_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested alert_guideline_step" do
      alert_guideline_step = AlertGuidelineStep.create! valid_attributes
      expect {
        delete :destroy, {:id => alert_guideline_step.to_param}, valid_session
      }.to change(AlertGuidelineStep, :count).by(-1)
    end

    it "redirects to the alert_guideline_steps list" do
      alert_guideline_step = AlertGuidelineStep.create! valid_attributes
      delete :destroy, {:id => alert_guideline_step.to_param}, valid_session
      response.should redirect_to(alert_guideline_steps_url)
    end
  end

end
