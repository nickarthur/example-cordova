package io.hypertrack.cordova;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import com.google.gson.Gson;

import android.content.Context;

import io.hypertrack.lib.common.HyperTrack;
import io.hypertrack.lib.transmitter.service.HTTransmitterService;
import io.hypertrack.lib.transmitter.model.HTTrip;
import io.hypertrack.lib.transmitter.model.HTShift;
import io.hypertrack.lib.transmitter.model.HTTripParams;
import io.hypertrack.lib.transmitter.model.HTShiftParams;
import io.hypertrack.lib.transmitter.model.HTTripParamsBuilder;
import io.hypertrack.lib.transmitter.model.HTShiftParamsBuilder;
import io.hypertrack.lib.transmitter.model.callback.HTTripStatusCallback;
import io.hypertrack.lib.transmitter.model.callback.HTShiftStatusCallback;
import io.hypertrack.lib.transmitter.model.callback.HTCompleteTaskStatusCallback;


/**
 * This class calls SDK methods.
 */
public class HyperTrackWrapper extends CordovaPlugin {

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.setPk();
    }

    private void setPk() {
        Context context = this.cordova.getActivity().getApplicationContext();
        HyperTrack.setPublishableApiKey(this.getHyperTrackKey(), context);
        HTTransmitterService.initHTTransmitter(context);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.setPk();

        if (action.equals("helloWorld")) {
            String name = args.getString(0);
            this.helloWorld(name, callbackContext);
            return true;
        }

        if (action.equals("startTrip")) {
            String driverID = args.getString(0);
            JSONArray jsonTaskIDs = args.getJSONArray(1);
            ArrayList<String> taskIDs = new ArrayList<String>();

            for (int i=0; i < jsonTaskIDs.length(); i++) {
                taskIDs.add(jsonTaskIDs.getString(i));
            }

            this.startTrip(driverID, taskIDs, callbackContext);
            return true;
        }

        if (action.equals("completeTask")) {
            String taskID = args.getString(0);
            this.completeTask(taskID, callbackContext);
            return true;
        }

        if (action.equals("endTrip")) {
            String tripID = args.getString(0);
            this.endTrip(tripID, callbackContext);
            return true;
        }

        if (action.equals("startShift")) {
            String driverID = args.getString(0);
            this.startShift(driverID, callbackContext);
            return true;
        }

        if (action.equals("endShift")) {
            this.endShift(callbackContext);
            return true;
        }

        if (action.equals("connectDriver")) {
            String driverID = args.getString(0);
            this.connectDriver(driverID, callbackContext);
            return true;
        }

        if (action.equals("isTransmitting")) {
            this.isTransmitting(callbackContext);
            return true;
        }

        if (action.equals("getActiveDriver")) {
            this.getActiveDriver(callbackContext);
            return true;
        }

        if (action.equals("getPublishableKey")) {
            this.getPublishableKey(callbackContext);
            return true;
        }

        return false;
    }

    private String getHyperTrackKey() {
        return preferences.getString("HYPERTRACK_PK", "");
    }

    private void helloWorld(String name, CallbackContext callbackContext) {
        callbackContext.success(name);
    }

    private void startTrip(String driverID, ArrayList<String> taskIDs, final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);

        HTTripParams htTripParams = new HTTripParamsBuilder().setDriverID(driverID)
                .setTaskIDs(taskIDs)
                .setOrderedTasks(false)
                .setIsAutoEnded(false)
                .createHTTripParams();

        transmitterService.startTrip(htTripParams, new HTTripStatusCallback() {
            @Override
            public void onSuccess(boolean isOffline, HTTrip htTrip) {
                try {
                    Gson gson = new Gson();
                    String tripJson = gson.toJson(htTrip);
                    JSONObject result = new JSONObject();
                    result.put("is_offline", isOffline);
                    result.put("trip", tripJson);
                    callbackContext.success(result);
                } catch (JSONException e) {
                    callbackContext.success("");
                }
            }

            @Override
            public void onError(Exception e) {
                try {
                    JSONObject result = new JSONObject();
                    if (e == null) {
                        result.put("error", "");
                    } else {
                        result.put("error", e.toString());
                    }
                    callbackContext.error(result);
                } catch (JSONException exception) {
                    callbackContext.error("");
                }
            }
        });
    }

    private void completeTask(String taskID, final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);

        transmitterService.completeTask(taskID, new HTCompleteTaskStatusCallback() {
            @Override
            public void onSuccess(String taskID) {
                try {
                    JSONObject result = new JSONObject();
                    result.put("task_id", taskID);
                    callbackContext.success(result);
                } catch (JSONException e) {
                    callbackContext.success("");
                }
            }

            @Override
            public void onError(Exception e) {
                try {
                    JSONObject result = new JSONObject();
                    if (e == null) {
                        result.put("error", "");
                    } else {
                        result.put("error", e.toString());
                    }
                    callbackContext.error(result);
                } catch (JSONException exception) {
                    callbackContext.error("");
                }
            }
        });
    }

    private void endTrip(String tripID, final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);

        transmitterService.endTrip(tripID, new HTTripStatusCallback() {
            @Override
            public void onSuccess(boolean isOffline, HTTrip htTrip) {
                try {
                    Gson gson = new Gson();
                    String tripJson = gson.toJson(htTrip);
                    JSONObject result = new JSONObject();
                    result.put("is_offline", isOffline);
                    result.put("trip", tripJson);
                    callbackContext.success(result);
                } catch (JSONException e) {
                    callbackContext.success("");
                }
            }

            @Override
            public void onError(Exception e) {
                try {
                    JSONObject result = new JSONObject();
                    if (e == null) {
                        result.put("error", "");
                    } else {
                        result.put("error", e.toString());
                    }
                    callbackContext.error(result);
                } catch (JSONException exception) {
                    callbackContext.error("");
                }
            }
        });
    }

    private void startShift(String driverID, final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);

        HTShiftParamsBuilder htShiftParamsBuilder = new HTShiftParamsBuilder();
        HTShiftParams htShiftParams = htShiftParamsBuilder.setDriverID(driverID).createHTShiftParams();

        transmitterService.startShift(htShiftParams, new HTShiftStatusCallback() {
            @Override
            public void onSuccess(HTShift htShift) {
                try {
                    Gson gson = new Gson();
                    String shiftJson = gson.toJson(htShift);
                    JSONObject result = new JSONObject();
                    result.put("shift", shiftJson);
                    callbackContext.success(result);
                } catch (JSONException e) {
                    callbackContext.success("");
                }
            }

            @Override
            public void onError(Exception e) {
                try {
                    JSONObject result = new JSONObject();
                    if (e == null) {
                        result.put("error", "");
                    } else {
                        result.put("error", e.toString());
                    }
                    callbackContext.error(result);
                } catch (JSONException exception) {
                    callbackContext.error("");
                }
            }
        });
    }

    private void endShift(final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);

        transmitterService.endShift(new HTShiftStatusCallback() {
            @Override
            public void onError(Exception e) {
                //Log error.getMessage() here or do something
                try {
                    JSONObject result = new JSONObject();
                    if (e == null) {
                        result.put("error", "");
                    } else {
                        result.put("error", e.toString());
                    }
                    callbackContext.error(result);
                } catch (JSONException exception) {
                    callbackContext.error("");
                }
            }

            @Override
            public void onSuccess(HTShift htShift) {
                try {
                    Gson gson = new Gson();
                    String shiftJson = gson.toJson(htShift);
                    JSONObject result = new JSONObject();
                    result.put("shift", shiftJson);
                    callbackContext.success(result);
                } catch (JSONException e) {
                    callbackContext.success("");
                }
            }
        });
    }

    private void connectDriver(String driverID, final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);
    }

    private void isTransmitting(final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);
    }

    private void getActiveDriver(final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);
    }

    private void getPublishableKey(final CallbackContext callbackContext) {
        Context context = this.cordova.getActivity().getApplicationContext();
        HTTransmitterService transmitterService = HTTransmitterService.getInstance(context);
    }
}
