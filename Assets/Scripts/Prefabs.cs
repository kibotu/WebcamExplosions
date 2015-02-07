using UnityEngine;
using System.Collections;

namespace WebcamExplosions
{
	public class Prefabs : MonoBehaviour
	{

		#region Singleton
		
		private static volatile Prefabs _instance;
		private static readonly object SyncRoot = new Object ();
		
		public static Prefabs Shared {
			get {
				if (_instance == null) {
					lock (SyncRoot) {
						return _instance ?? (_instance = ((GameObject)Resources.Load ("Prefabs", typeof(GameObject))).GetComponent<Prefabs> ());
					}
				}
				
				return _instance;
			}
		}

		#endregion

		public GameObject Explosion;
	    public GameObject Button;
	}

	public static class GameObjectExtensions
	{
		public static GameObject Instantiate (this GameObject prefab)
		{
			return Object.Instantiate (prefab) as GameObject;
		}
	}
}