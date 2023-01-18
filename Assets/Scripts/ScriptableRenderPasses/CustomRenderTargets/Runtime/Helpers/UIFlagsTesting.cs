using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace ScriptableRenderPasses
{
    public class UIFlagsTesting
    {
        public enum ExampleFlags
        {
            None = 0,
            A = 1,
            B = 1 << 1,
            C = 4,
            AB = A | B,
            AC = A | C,
            BC = B | C
        }

        private ExampleFlags _uiFlags;
        private Action _exampleAction; // = () => {};

        private void TestOne()
        {
            Debug.Log("TestOne");
        }
        private void TestTwo()
        {
            Debug.Log("TestTwo");
        }
        private void TestThree()
        {
            Debug.Log("TestThree");
        }

        private Dictionary<ExampleFlags, Action> FlagActionDictionary => new()
        {
            [ExampleFlags.A] = TestOne,
            [ExampleFlags.B] = TestTwo,
            [ExampleFlags.C] = TestThree
        };
        
        public void AddGUIActions()
        {
            _uiFlags = ExampleFlags.AC;

            foreach (var key in FlagActionDictionary.Keys.Where(key => _uiFlags.HasFlag(key)))
            {
                _exampleAction += FlagActionDictionary[key];
            }

            _exampleAction.Invoke();
        }


    }
}