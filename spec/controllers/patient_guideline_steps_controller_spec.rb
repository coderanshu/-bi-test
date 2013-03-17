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

describe PatientGuidelineStepsController do

  # This should return the minimal set of attributes required to create a valid
  # PatientGuidelineStep. As you add validations to PatientGuidelineStep, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "patient_guideline_id" => "1" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PatientGuidelineStepsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all patient_guideline_steps as @patient_guideline_steps" do
      patient_guideline_step = PatientGuidelineStep.create! valid_attributes
      get :index, {}, valid_session
      assigns(:patient_guideline_steps).should eq([patient_guideline_step])
    end
  end

  describe "GET show" do
    it "assigns the requested patient_guideline_step as @patient_guideline_step" do
      patient_guideline_step = PatientGuidelineStep.create! valid_attributes
      get :show, {:id => patient_guideline_step.to_param}, valid_session
      assigns(:patient_guideline_step).should eq(patient_guideline_step)
    end
  end

  describe "GET new" do
    it "assigns a new patient_guideline_step as @patient_guideline_step" do
      get :new, {}, valid_session
      assigns(:patient_guideline_step).should be_a_new(PatientGuidelineStep)
    end
  end

  describe "GET edit" do
    it "assigns the requested patient_guideline_step as @patient_guideline_step" do
      patient_guideline_step = PatientGuidelineStep.create! valid_attributes
      get :edit, {:id => patient_guideline_step.to_param}, valid_session
      assigns(:patient_guideline_step).should eq(patient_guideline_step)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PatientGuidelineStep" do
        expect {
          post :create, {:patient_guideline_step => valid_attributes}, valid_session
        }.to change(PatientGuidelineStep, :count).by(1)
      end

      it "assigns a newly created patient_guideline_step as @patient_guideline_step" do
        post :create, {:patient_guideline_step => valid_attributes}, valid_session
        assigns(:patient_guideline_step).should be_a(PatientGuidelineStep)
        assigns(:patient_guideline_step).should be_persisted
      end

      it "redirects to the created patient_guideline_step" do
        post :create, {:patient_guideline_step => valid_attributes}, valid_session
        response.should redirect_to(PatientGuidelineStep.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved patient_guideline_step as @patient_guideline_step" do
        # Trigger the behavior that occurs when invalid params are submitted
        PatientGuidelineStep.any_instance.stub(:save).and_return(false)
        post :create, {:patient_guideline_step => { "patient_guideline_id" => "invalid value" }}, valid_session
        assigns(:patient_guideline_step).should be_a_new(PatientGuidelineStep)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PatientGuidelineStep.any_instance.stub(:save).and_return(false)
        post :create, {:patient_guideline_step => { "patient_guideline_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested patient_guideline_step" do
        patient_guideline_step = PatientGuidelineStep.create! valid_attributes
        # Assuming there are no other patient_guideline_steps in the database, this
        # specifies that the PatientGuidelineStep created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PatientGuidelineStep.any_instance.should_receive(:update_attributes).with({ "patient_guideline_id" => "1" })
        put :update, {:id => patient_guideline_step.to_param, :patient_guideline_step => { "patient_guideline_id" => "1" }}, valid_session
      end

      it "assigns the requested patient_guideline_step as @patient_guideline_step" do
        patient_guideline_step = PatientGuidelineStep.create! valid_attributes
        put :update, {:id => patient_guideline_step.to_param, :patient_guideline_step => valid_attributes}, valid_session
        assigns(:patient_guideline_step).should eq(patient_guideline_step)
      end

      it "redirects to the patient_guideline_step" do
        patient_guideline_step = PatientGuidelineStep.create! valid_attributes
        put :update, {:id => patient_guideline_step.to_param, :patient_guideline_step => valid_attributes}, valid_session
        response.should redirect_to(patient_guideline_step)
      end
    end

    describe "with invalid params" do
      it "assigns the patient_guideline_step as @patient_guideline_step" do
        patient_guideline_step = PatientGuidelineStep.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PatientGuidelineStep.any_instance.stub(:save).and_return(false)
        put :update, {:id => patient_guideline_step.to_param, :patient_guideline_step => { "patient_guideline_id" => "invalid value" }}, valid_session
        assigns(:patient_guideline_step).should eq(patient_guideline_step)
      end

      it "re-renders the 'edit' template" do
        patient_guideline_step = PatientGuidelineStep.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PatientGuidelineStep.any_instance.stub(:save).and_return(false)
        put :update, {:id => patient_guideline_step.to_param, :patient_guideline_step => { "patient_guideline_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested patient_guideline_step" do
      patient_guideline_step = PatientGuidelineStep.create! valid_attributes
      expect {
        delete :destroy, {:id => patient_guideline_step.to_param}, valid_session
      }.to change(PatientGuidelineStep, :count).by(-1)
    end

    it "redirects to the patient_guideline_steps list" do
      patient_guideline_step = PatientGuidelineStep.create! valid_attributes
      delete :destroy, {:id => patient_guideline_step.to_param}, valid_session
      response.should redirect_to(patient_guideline_steps_url)
    end
  end

end
