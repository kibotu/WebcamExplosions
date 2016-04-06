using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace WebcamExplosions
{
	public class WebCam : MonoBehaviour
	{
	    public GridLayoutGroup Grid;

		void Start () {
			StartCoroutine(RequestAuthorization());
		}

		IEnumerator RequestAuthorization() {
			yield return Application.RequestUserAuthorization(UserAuthorization.WebCam );
			if (Application.HasUserAuthorization(UserAuthorization.WebCam)) {

                var devices = WebCamTexture.devices;
			    foreach (var webCamDevice in devices)
			    {
					Debug.Log ("webCamDevice " + webCamDevice.name);
			        var button = Prefabs.Shared.Button.Instantiate().GetComponent<Button>();
			        button.transform.SetParent(Grid.gameObject.transform);
			        button.GetComponentInChildren<Text>().text = webCamDevice.name;
			        var device = webCamDevice;
			        button.onClick.AddListener(() =>
			        {
			            StartWebcamStream(device.name);
			            StartAudioStream();
			            Grid.gameObject.SetActive(false);
			        });
			      break;
			    }

			} else {
				Debug.Log ("meh~");
			}
		}

	    private void StartAudioStream()
	    {
	        //var aud = gameObject.AddComponent<AudioSource>();
            //aud.clip = Microphone.Start(null, false, 10, 44100);
            //aud.Play();
	    }

	    private void StartWebcamStream(string name)
	    {
	        var webcamTexture = new WebCamTexture {deviceName = name, requestedWidth = Screen.width, requestedHeight = Screen.height, requestedFPS = 60};
	        GetComponent<MeshRenderer>().material.mainTexture = webcamTexture;
	        webcamTexture.Play();
	    }

	    public void OnMouseDown()
		{
            if(Grid.gameObject.activeSelf)
                return;
			var pos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, -Camera.main.transform.position.z));
			Prefabs.Shared.Explosion.Instantiate().transform.position = pos;
		}
	}
}