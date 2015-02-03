using UnityEngine;
using System.Collections;

namespace WebcamExplosions
{
	public class WebCam : MonoBehaviour {

		void Start () {
			WebCamTexture webcamTexture = new WebCamTexture();
			GetComponent<MeshRenderer>().material.mainTexture = webcamTexture;
			webcamTexture.Play();
		}

		public void OnMouseDown() 
		{
			Vector3 pos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, -Camera.main.transform.position.z));


			Prefabs.Shared.Explosion.Instantiate().transform.position = pos;
		}
	}
}